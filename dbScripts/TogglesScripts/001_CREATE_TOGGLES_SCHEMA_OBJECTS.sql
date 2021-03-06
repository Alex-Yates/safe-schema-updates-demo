/****** Object:  Table [dbo].[Feature]    Script Date: 21/08/2020 09:44:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Feature](
	[FeatureID] [int] NOT NULL,
	[FeatureName] [nvarchar](50) NOT NULL,
	[Enabled] [bit] NOT NULL,
	[Throttle] [int] NOT NULL,
	[DarkLaunch] [bit] NOT NULL,
 CONSTRAINT [PK_Feature_FeatureID] PRIMARY KEY CLUSTERED 
(
	[FeatureID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Feature] ADD  CONSTRAINT [DF_Feature_EnabledPublic]  DEFAULT ((0)) FOR [Enabled]
GO
ALTER TABLE [dbo].[Feature] ADD  CONSTRAINT [DF_Feature_Throttle]  DEFAULT ((100)) FOR [Throttle]
GO
ALTER TABLE [dbo].[Feature] ADD  CONSTRAINT [DF_Feature_DarkLaunch]  DEFAULT ((0)) FOR [DarkLaunch]
GO
