USE Club02
GO

DELETE FROM dbo.Unlimit_SystemRate

INSERT INTO dbo.Unlimit_SystemRate(PlatformID, Level, LevelName, MinAmount, MaxAmount, BonusAmount) VALUES(2,  1, '普通玩家',     0,          200000, 50);
INSERT INTO dbo.Unlimit_SystemRate(PlatformID, Level, LevelName, MinAmount, MaxAmount, BonusAmount) VALUES(2,  2, '资深玩家',     200000,     500000, 55);
INSERT INTO dbo.Unlimit_SystemRate(PlatformID, Level, LevelName, MinAmount, MaxAmount, BonusAmount) VALUES(2,  3, '超级玩家',     500000,    1000000, 60);
INSERT INTO dbo.Unlimit_SystemRate(PlatformID, Level, LevelName, MinAmount, MaxAmount, BonusAmount) VALUES(2,  4, '青铜会员',     1000000,   2000000, 65);
INSERT INTO dbo.Unlimit_SystemRate(PlatformID, Level, LevelName, MinAmount, MaxAmount, BonusAmount) VALUES(2,  5, '白银会员',     2000000,   5000000, 70);
INSERT INTO dbo.Unlimit_SystemRate(PlatformID, Level, LevelName, MinAmount, MaxAmount, BonusAmount) VALUES(2,  6, '黄金会员',     5000000,  10000000, 75);
INSERT INTO dbo.Unlimit_SystemRate(PlatformID, Level, LevelName, MinAmount, MaxAmount, BonusAmount) VALUES(2,  7, '钻石会员',    10000000,  15000000, 80);
INSERT INTO dbo.Unlimit_SystemRate(PlatformID, Level, LevelName, MinAmount, MaxAmount, BonusAmount) VALUES(2,  8, '青铜代理',    15000000,  20000000, 85);
INSERT INTO dbo.Unlimit_SystemRate(PlatformID, Level, LevelName, MinAmount, MaxAmount, BonusAmount) VALUES(2,  9, '白银代理',    20000000,  25000000, 90);
INSERT INTO dbo.Unlimit_SystemRate(PlatformID, Level, LevelName, MinAmount, MaxAmount, BonusAmount) VALUES(2, 10, '黄金代理',    25000000,  30000000, 95);
INSERT INTO dbo.Unlimit_SystemRate(PlatformID, Level, LevelName, MinAmount, MaxAmount, BonusAmount) VALUES(2, 11, '钻石代理',    30000000,  40000000, 100);
INSERT INTO dbo.Unlimit_SystemRate(PlatformID, Level, LevelName, MinAmount, MaxAmount, BonusAmount) VALUES(2, 12, '区域经理',    40000000,  50000000, 105);
INSERT INTO dbo.Unlimit_SystemRate(PlatformID, Level, LevelName, MinAmount, MaxAmount, BonusAmount) VALUES(2, 13, '总代理',      50000000,  60000000, 110);
INSERT INTO dbo.Unlimit_SystemRate(PlatformID, Level, LevelName, MinAmount, MaxAmount, BonusAmount) VALUES(2, 14, '超级总代理',  60000000,  80000000, 115);
INSERT INTO dbo.Unlimit_SystemRate(PlatformID, Level, LevelName, MinAmount, MaxAmount, BonusAmount) VALUES(2, 15, '总监',        80000000, 100000000, 120);
INSERT INTO dbo.Unlimit_SystemRate(PlatformID, Level, LevelName, MinAmount, MaxAmount, BonusAmount) VALUES(2, 16, '中级总监',   100000000, 150000000, 125);
INSERT INTO dbo.Unlimit_SystemRate(PlatformID, Level, LevelName, MinAmount, MaxAmount, BonusAmount) VALUES(2, 17, '高级总监',   150000000, 200000000, 130);
INSERT INTO dbo.Unlimit_SystemRate(PlatformID, Level, LevelName, MinAmount, MaxAmount, BonusAmount) VALUES(2, 18, '超级总监',   200000000, 250000000, 135);
INSERT INTO dbo.Unlimit_SystemRate(PlatformID, Level, LevelName, MinAmount, MaxAmount, BonusAmount) VALUES(2, 19, '元老',       250000000, 300000000, 140);
INSERT INTO dbo.Unlimit_SystemRate(PlatformID, Level, LevelName, MinAmount, MaxAmount, BonusAmount) VALUES(2, 20, '股东',       300000000, 350000000, 145);
INSERT INTO dbo.Unlimit_SystemRate(PlatformID, Level, LevelName, MinAmount, MaxAmount, BonusAmount) VALUES(2, 21, '高级股东',   350000000, 400000000, 150);
INSERT INTO dbo.Unlimit_SystemRate(PlatformID, Level, LevelName, MinAmount, MaxAmount, BonusAmount) VALUES(2, 22, '董事',       400000000, 500000000, 155);
INSERT INTO dbo.Unlimit_SystemRate(PlatformID, Level, LevelName, MinAmount, MaxAmount, BonusAmount) VALUES(2, 23, '合伙人',     500000000, 0, 160);
