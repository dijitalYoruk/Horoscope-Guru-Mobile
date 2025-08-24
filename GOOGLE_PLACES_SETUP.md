# Google Places API Setup Guide

This guide explains how to set up the Google Places API for the birth place search functionality in the Horoscope Guru app.

## Prerequisites

1. A Google Cloud Platform account
2. A project in Google Cloud Console
3. Billing enabled on your project

## Step 1: Enable the Places API

1. Go to the [Google Cloud Console](https://console.cloud.google.com/)
2. Select your project
3. Navigate to "APIs & Services" > "Library"
4. Search for "Places API"
5. Click on "Places API" and then click "Enable"

## Step 2: Create API Credentials

1. In the Google Cloud Console, go to "APIs & Services" > "Credentials"
2. Click "Create Credentials" > "API Key"
3. Copy the generated API key

## Step 3: Restrict the API Key (Recommended)

1. Click on the created API key to edit it
2. Under "Application restrictions", select "Android apps" or "iOS apps" depending on your target platform
3. Under "API restrictions", select "Restrict key" and choose "Places API"
4. Click "Save"

## Step 4: Update the App Configuration

1. Open `lib/utils/environment_keys.dart`
2. Replace `"YOUR_GOOGLE_PLACES_API_KEY"` with your actual API key:

```dart
static const String GooglePlacesApiKey = "your_actual_api_key_here";
```

## Step 5: Install Dependencies

Run the following command to install the required dependencies:

```bash
flutter pub get
```

## Features

The Google Places API integration provides:

- **Autocomplete Search**: As users type in birth place fields, they get real-time suggestions
- **City/Country Suggestions**: Focused on cities and countries for birth place accuracy
- **Debounced Search**: Prevents excessive API calls while typing
- **Formatted Addresses**: Clean, consistent address formatting
- **Cross-Platform**: Works on both Android and iOS

## Usage

The location search is automatically integrated into:

- User Profile Screen (birth place field)
- Add Person Screen (birth place field)
- Any other birth place input fields in the app

## API Limits and Costs

- **Free Tier**: $200 credit per month
- **Places API Autocomplete**: $2.83 per 1000 requests
- **Monitor Usage**: Check your Google Cloud Console billing section

## Troubleshooting

### Common Issues:

1. **"API key not valid" error**: Ensure your API key is correct and the Places API is enabled
2. **No suggestions appearing**: Check if billing is enabled and the API key has proper restrictions
3. **Rate limiting**: The app includes debouncing to prevent excessive API calls

### Testing:

1. Test with a valid API key
2. Ensure internet connectivity
3. Check console logs for any error messages

## Security Notes

- Never commit API keys to version control
- Use environment variables or secure key management in production
- Restrict API keys to specific platforms and APIs
- Monitor API usage regularly

## Support

For Google Places API issues, refer to:
- [Google Places API Documentation](https://developers.google.com/maps/documentation/places/web-service)
- [Google Cloud Console](https://console.cloud.google.com/)
- [Google Cloud Support](https://cloud.google.com/support) 