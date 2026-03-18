# CoreData + CloudKit Setup Guide

This guide walks you through setting up the CoreData model in Xcode for iCloud sync functionality.

## Prerequisites

- Xcode 15.0 or later
- Apple Developer Account (for CloudKit)
- iOS 16.0+ deployment target

---

## Step 1: Create the CoreData Model File

1. Open `StitchVision.xcodeproj` in Xcode

2. Navigate to `StitchVision/Data/CoreData/` folder in the Project Navigator
   - If the folder doesn't exist, create it: Right-click `Data` → New Group → Name it `CoreData`

3. Create the Data Model:
   - Right-click `CoreData` folder → **New File...**
   - Select **Data Model** under Core Data section
   - Click **Next**
   - Name it `StitchVision`
   - Click **Create**

4. Xcode will create `StitchVision.xcdatamodeld`

---

## Step 2: Create Entities

Open `StitchVision.xcdatamodeld` and create the following 5 entities:

### UserProfileEntity

| Attribute | Type | Optional | Default |
|-----------|------|----------|---------|
| id | UUID | No | - |
| name | String | Yes | - |
| email | String | Yes | - |
| craftType | String | Yes | - |
| skillLevel | String | Yes | - |
| struggles | String | Yes | - |
| habitFrequency | String | Yes | - |
| goal | String | Yes | - |
| isPro | Boolean | No | NO |
| hasCompletedOnboarding | Boolean | No | NO |
| createdAt | Date | Yes | - |
| updatedAt | Date | Yes | - |

### ProjectEntity

| Attribute | Type | Optional | Default |
|-----------|------|----------|---------|
| id | UUID | No | - |
| userId | UUID | Yes | - |
| name | String | No | - |
| craftType | String | Yes | - |
| needleSize | String | Yes | - |
| yarnType | String | Yes | - |
| yarnColor | String | Yes | - |
| patternName | String | Yes | - |
| totalRows | Integer 32 | No | 0 |
| currentRow | Integer 32 | No | 0 |
| status | String | Yes | "active" |
| createdAt | Date | Yes | - |
| updatedAt | Date | Yes | - |

### SessionEntity

| Attribute | Type | Optional | Default |
|-----------|------|----------|---------|
| id | UUID | No | - |
| projectId | UUID | Yes | - |
| rowsKnit | Integer 32 | No | 0 |
| timeSpent | Integer 32 | No | 0 |
| startTime | Date | Yes | - |
| endTime | Date | Yes | - |
| createdAt | Date | Yes | - |

### PatternEntity

| Attribute | Type | Optional | Default |
|-----------|------|----------|---------|
| id | UUID | No | - |
| name | String | No | - |
| imageData | Binary Data | Yes | - |
| totalRows | Integer 32 | No | 0 |
| currentRow | Integer 32 | No | 0 |
| completedRows | String | Yes | - |
| projectId | UUID | Yes | - |
| createdAt | Date | Yes | - |
| updatedAt | Date | Yes | - |

### SettingsEntity

| Attribute | Type | Optional | Default |
|-----------|------|----------|---------|
| id | UUID | No | - |
| key | String | No | - |
| value | String | Yes | - |
| updatedAt | Date | Yes | - |

---

## Step 3: Configure Code Generation

For each entity:

1. Select the entity in the model editor
2. Open the **Data Model Inspector** (right panel)
3. Set **Codegen** to **Manual/None**
   - This is required because we have custom `Entities.swift` file

---

## Step 4: Enable CloudKit Sync

1. Select `StitchVision.xcdatamodeld` in Project Navigator

2. Open the **File Inspector** (left panel)

3. Check **Used with CloudKit**

4. Set **Container Identifier** to: `iCloud.com.stitchvision.app`

   > **Note:** This must match the container in your Apple Developer Account

---

## Step 5: Add iCloud Capability

1. Select the **StitchVision** target in Project Settings

2. Go to **Signing & Capabilities** tab

3. Click **+ Capability**

4. Search for and add **iCloud**

5. Configure iCloud:
   - Check **CloudKit**
   - Check **Key-value storage**
   - Click **+** under Containers
   - Add: `iCloud.com.stitchvision.app`

---

## Step 6: Configure Entitlements

The `StitchVision.entitlements` file should contain:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>aps-environment</key>
    <string>development</string>
    <key>com.apple.developer.icloud-container-identifiers</key>
    <array>
        <string>iCloud.com.stitchvision.app</string>
    </array>
    <key>com.apple.developer.icloud-services</key>
    <array>
        <string>CloudDocuments</string>
        <string>CloudKit</string>
    </array>
    <key>com.apple.developer.ubiquity-kvstore-identifier</key>
    <string>$(TeamIdentifierPrefix)com.stitchvision.app</string>
</dict>
</plist>
```

To use the existing entitlements file:

1. In Project Settings → **Build Settings**
2. Search for "Entitlements"
3. Set **Code Signing Entitlements** to:
   ```
   StitchVision/Resources/StitchVision.entitlements
   ```

---

## Step 7: Verify CoreDataManager Integration

The `CoreDataManager.swift` file handles all persistence. Verify it loads correctly:

1. Open `CoreDataManager.swift`
2. Ensure the container name matches your model:
   ```swift
   persistentContainer = NSPersistentCloudKitContainer(name: "StitchVision")
   ```

3. Ensure the CloudKit container identifier matches:
   ```swift
   description.cloudKitContainerOptions = NSPersistentCloudKitContainerOptions(
       containerIdentifier: "iCloud.com.stitchvision.app"
   )
   ```

---

## Step 8: Test Sync

### Local Testing

1. Run the app on Simulator
2. Create a project
3. Check Console for CoreData logs

### CloudKit Sync Testing

1. Run the app on two different simulators (same iCloud account)
2. Create data on one device
3. Verify it appears on the other device

### Debug CloudKit

In Safari, navigate to:
```
https://icloud.developer.apple.com/
```

1. Log in with your Apple ID
2. Select your container: `iCloud.com.stitchvision.app`
3. View records in **Schema** and **Logs**

---

## Troubleshooting

### "Model not found" Error

- Ensure `StitchVision.xcdatamodeld` is in the correct location
- Check that it's included in the StitchVision target (Target Membership)

### CloudKit Sync Not Working

1. Check internet connection
2. Verify iCloud is logged in on device
3. Check CloudKit Dashboard for errors
4. Ensure container identifier matches exactly

### Migration Issues

The `CoreDataManager` includes SQLite to CoreData migration. If you encounter issues:

1. Delete the app from simulator
2. Clean build folder (Cmd+Shift+K)
3. Rebuild and run

### "Entity not found" Errors

- Ensure entity names in code match exactly:
  - `UserProfileEntity`
  - `ProjectEntity`
  - `SessionEntity`
  - `PatternEntity`
  - `SettingsEntity`

---

## File Locations

```
StitchVision/
├── Data/
│   ├── CoreData/
│   │   ├── StitchVision.xcdatamodeld/  ← Create this in Xcode
│   │   └── Entities.swift              ← Already exists
│   └── CoreDataManager.swift           ← Already exists
└── Resources/
    ├── StitchVision.entitlements       ← Already exists
    └── Products.storekit               ← Already exists
```

---

## Next Steps

After completing CoreData setup:

1. **App Store Connect**: Create the app record
2. **CloudKit Schema**: Deploy schema to Production
3. **Test Flight**: Beta test sync functionality
4. **Production**: Submit to App Store

---

## Resources

- [Apple CoreData Documentation](https://developer.apple.com/documentation/coredata)
- [CloudKit Framework](https://developer.apple.com/documentation/cloudkit)
- [NSPersistentCloudKitContainer](https://developer.apple.com/documentation/coredata/nspersistentcloudkitcontainer)
