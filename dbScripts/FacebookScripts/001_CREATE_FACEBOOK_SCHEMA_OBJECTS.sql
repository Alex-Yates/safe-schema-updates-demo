/****** Object:  Table [dbo].[Relationship]    Script Date: 21/08/2020 09:40:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Relationship](
	[RelationshipID] [int] NOT NULL,
	[User1ID] [int] NOT NULL,
	[User2ID] [int] NOT NULL,
 CONSTRAINT [PK_Relationship_RelationshipID] PRIMARY KEY CLUSTERED 
(
	[RelationshipID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[User]    Script Date: 21/08/2020 09:40:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[User](
	[UserID] [int] NOT NULL,
	[UserName] [nvarchar](50) NOT NULL,
	[Online] [bit] NOT NULL,
 CONSTRAINT [PK_User_UserID] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Relationship]  WITH CHECK ADD  CONSTRAINT [FK_Relationship_User1] FOREIGN KEY([User1ID])
REFERENCES [dbo].[User] ([UserID])
GO
ALTER TABLE [dbo].[Relationship] CHECK CONSTRAINT [FK_Relationship_User1]
GO
ALTER TABLE [dbo].[Relationship]  WITH CHECK ADD  CONSTRAINT [FK_Relationship_User2] FOREIGN KEY([User2ID])
REFERENCES [dbo].[User] ([UserID])
GO
ALTER TABLE [dbo].[Relationship] CHECK CONSTRAINT [FK_Relationship_User2]
GO
/****** Object:  StoredProcedure [dbo].[FriendsOf]    Script Date: 21/08/2020 09:40:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SET QUOTED_IDENTIFIER ON|OFF
--SET ANSI_NULLS ON|OFF
--GO
CREATE PROCEDURE [dbo].[FriendsOf] @UserId AS INT
AS
BEGIN
	DECLARE @Feature NVARCHAR(50) 
	SET @Feature = N'live buttons'
	PRINT CONCAT('Feature Toggle detected: ', @Feature)

	DECLARE @Enabled BIT
	SET @Enabled = (SELECT Enabled FROM Toggles.dbo.Feature WHERE FeatureName LIKE @Feature);
	IF (@Enabled = 1)
	BEGIN
		PRINT 'Enabled: TRUE'
	END
	ELSE
	BEGIN
		PRINT 'Enabled: FALSE'
	END

	DECLARE @Throttle INT
	SET @Throttle = (SELECT Throttle FROM Toggles.dbo.Feature WHERE FeatureName LIKE @Feature);
	PRINT CONCAT('Throttle: ', @Throttle)

	DECLARE @DarkLaunch BIT
	SET @DarkLaunch = (SELECT DarkLaunch FROM Toggles.dbo.Feature WHERE FeatureName LIKE @Feature);
	IF (@Throttle < (SELECT RAND()*100))
		BEGIN
			SET @DarkLaunch = 0;
		END
	IF (@DarkLaunch = 1)
	BEGIN
		PRINT 'DarkLaunch: TRUE'
	END
	ELSE
	BEGIN
		PRINT 'DarkLaunch: FALSE'
	END

	-- Creating a temp table to hog up memory
		    
	CREATE TABLE #Friends (UserID INT NOT NULL,
			               UserName NVARCHAR(50) NULL,
			               Online BIT NULL);

	DECLARE @OriginalSql NVARCHAR(MAX)
	SET @OriginalSql = 
		  N'INSERT INTO #Friends (UserID)
			SELECT DISTINCT User1ID
			FROM [dbo].[Relationship]
			WHERE User2ID = @User;
			
			INSERT INTO #Friends (UserID)
			SELECT DISTINCT User2ID
			FROM [dbo].[Relationship]
			WHERE User1ID = @User;'

	DECLARE @NewSql NVARCHAR(MAX)
	SET @NewSql = 
		  N'-- Finding the IDs off all the given users friends
			
			INSERT INTO #Friends (UserID)
			SELECT DISTINCT User1ID
			FROM [dbo].[Relationship]
			WHERE User2ID = @User;
			
			INSERT INTO #Friends (UserID)
			SELECT DISTINCT User2ID
			FROM [dbo].[Relationship]
			WHERE User1ID = @User;

			-- !!! Using an inefficiant Cursor to check the names an find out if folks are online !!!

			DECLARE @currentUser INT
			DECLARE @UserName NVARCHAR(50)
			DECLARE @Online BIT

			DECLARE FriendsCursor CURSOR FOR
			SELECT UserID FROM #Friends
			
			OPEN FriendsCursor
			FETCH NEXT FROM FriendsCursor INTO @currentUser

			WHILE (@@FETCH_STATUS = 0)
				BEGIN					
					SET @Online = (SELECT Online FROM dbo.[User] WHERE UserID = @currentUser)
					UPDATE #Friends SET Online = @Online WHERE UserID = @currentUser 
					SET @UserName = (SELECT UserName FROM dbo.[User] WHERE UserID = @currentUser)
					UPDATE #Friends SET UserName = @UserName WHERE UserID = @currentUser 
					WAITFOR DELAY''00:00:00.200'';
					FETCH NEXT FROM FriendsCursor INTO @currentUser
				END
			CLOSE FriendsCursor
			DEALLOCATE FriendsCursor'

	-- Returning results
	DECLARE @OldSqlReturn NVARCHAR(MAX)
	SET @OldSqlReturn = 
		N'SELECT DISTINCT UserID
		  FROM #Friends;'

	DECLARE @NewSqlReturn NVARCHAR(MAX)
	SET @NewSqlReturn = 
		N'SELECT DISTINCT UserId, UserName, Online
		  FROM #Friends
		  ORDER BY Online DESC;'

	-- Do the new version EITHER if Enabled OR DarkLaunch 
	IF (@Enabled = 1 OR @DarkLaunch = 1)
		BEGIN
			-- Feature is enabled
			EXEC sp_executesql @NewSql, N'@User INT', @User = @UserId;
		END
	ELSE
		BEGIN
			-- Feature is disabled
			EXEC sp_executesql @OriginalSql, N'@User INT', @User = @UserId;
		END
	
	-- Only return the new results if feature is public
	IF (@Enabled = 1)		
		BEGIN
			-- Feature is enabled
			EXEC sp_executesql @NewSqlReturn, N'@User INT', @User = @UserId;
		END
	ELSE
		BEGIN
			-- Feature is disabled
			EXEC sp_executesql @OldSqlReturn, N'@User INT', @User = @UserId;
		END
END;
GO