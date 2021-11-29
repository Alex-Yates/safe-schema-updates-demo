-- Creating feature toggle
INSERT INTO dbo.Feature
(
    FeatureID,
    FeatureName,
    Enabled,
    Throttle,
	DarkLaunch
)
VALUES
(   1,       -- FeatureID - int
    N'live buttons', -- FeatureName - nvarchar(50)
    0,       -- Enabled - bit
    100,     -- Throttle - int
	0        -- DarkLaunch - bit
)