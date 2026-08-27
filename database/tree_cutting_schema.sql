-- Drop database if it exists and recreate
IF DB_ID(N'TreeCuttingDb') IS NOT NULL
BEGIN
    ALTER DATABASE [TreeCuttingDb] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE [TreeCuttingDb];
END
GO

CREATE DATABASE [TreeCuttingDb];
GO

USE [TreeCuttingDb];
GO

-- ApplicationType Table
CREATE TABLE dbo.ApplicationType (
    ApplicationTypeId INT IDENTITY(1,1) PRIMARY KEY,
    ApplicationTypeName NVARCHAR(200) NOT NULL,
    IsActive BIT NOT NULL DEFAULT 1
);

CREATE UNIQUE INDEX UX_ApplicationType_ApplicationTypeName
    ON dbo.ApplicationType (ApplicationTypeName);

GO

-- ApplicantType Table
CREATE TABLE dbo.ApplicantType (
    ApplicantTypeId INT IDENTITY(1,1) PRIMARY KEY,
    ApplicantTypeName NVARCHAR(100) NOT NULL,
    IsActive BIT NOT NULL DEFAULT 1
);

CREATE UNIQUE INDEX UX_ApplicantType_ApplicantTypeName
    ON dbo.ApplicantType (ApplicantTypeName);

GO

-- DocumentType Table
CREATE TABLE dbo.DocumentType (
    DocumentTypeId INT IDENTITY(1,1) PRIMARY KEY,
    DocumentTypeName NVARCHAR(200) NOT NULL,
    IsActive BIT NOT NULL DEFAULT 1
);

CREATE UNIQUE INDEX UX_DocumentType_DocumentTypeName
    ON dbo.DocumentType (DocumentTypeName);

GO

-- ApplicationTypeDocumentMapping Table
CREATE TABLE dbo.ApplicationTypeDocumentMapping (
    ApplicationTypeDocumentMappingId INT IDENTITY(1,1) PRIMARY KEY,
    ApplicationTypeId INT NOT NULL,
    DocumentTypeId INT NOT NULL,
    IsRequired BIT NOT NULL DEFAULT 1,
    DisplayOrder INT NOT NULL DEFAULT 0
);

CREATE UNIQUE INDEX UX_ApplicationTypeDocumentMapping
    ON dbo.ApplicationTypeDocumentMapping (ApplicationTypeId, DocumentTypeId);

GO

-- Application Table
CREATE TABLE dbo.Application (
    ApplicationId INT IDENTITY(1,1) PRIMARY KEY,
    ApplicationNumber NVARCHAR(50) NOT NULL,
    ApplicationTypeId INT NOT NULL,
    ApplicantTypeId INT NOT NULL,
    FullName NVARCHAR(200) NOT NULL,
    Address NVARCHAR(500) NULL,
    EmailId NVARCHAR(200) NULL,
    MobileNo NVARCHAR(20) NULL,
    AadharNo NVARCHAR(20) NULL,
    PetName NVARCHAR(100) NULL,
    PethNo NVARCHAR(50) NULL,
    ZoneNo NVARCHAR(50) NULL,
    PrabhagNo NVARCHAR(50) NULL,
    PropertyTaxNo NVARCHAR(100) NULL,
    TreeAddress NVARCHAR(500) NULL,
    TreeCuttingReason NVARCHAR(500) NULL,
    NumberOfTreeCutting INT NOT NULL DEFAULT 0,
    TreeSpecies NVARCHAR(200) NULL,
    CreatedDate DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    UpdatedDate DATETIME2 NULL,
    SubmittedDate DATETIME2 NULL,
    IsSubmitted BIT NOT NULL DEFAULT 0,
    Status NVARCHAR(50) NOT NULL DEFAULT 'Draft'
);

CREATE UNIQUE INDEX UX_Application_ApplicationNumber
    ON dbo.Application (ApplicationNumber);

CREATE INDEX IX_Application_ApplicationTypeId
    ON dbo.Application (ApplicationTypeId);

CREATE INDEX IX_Application_ApplicantTypeId
    ON dbo.Application (ApplicantTypeId);

GO

-- ApplicationDocument Table
CREATE TABLE dbo.ApplicationDocument (
    ApplicationDocumentId INT IDENTITY(1,1) PRIMARY KEY,
    ApplicationId INT NOT NULL,
    ApplicationTypeId INT NOT NULL,
    DocumentTypeId INT NOT NULL,
    FileName NVARCHAR(255) NOT NULL,
    FilePath NVARCHAR(500) NOT NULL,
    ContentType NVARCHAR(200) NULL,
    UploadedDate DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
);

CREATE INDEX IX_ApplicationDocument_ApplicationId
    ON dbo.ApplicationDocument (ApplicationId);

CREATE INDEX IX_ApplicationDocument_ApplicationTypeId
    ON dbo.ApplicationDocument (ApplicationTypeId);

CREATE INDEX IX_ApplicationDocument_DocumentTypeId
    ON dbo.ApplicationDocument (DocumentTypeId);

GO
