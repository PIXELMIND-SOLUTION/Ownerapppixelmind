import 'package:flutter/material.dart';
import '../models/models.dart';

// ─── Mock login credentials ───────────────────────────────────────────────────

final Map<String, String> mockLoginCredentials = {
  'alex@techcorp.com': 'pass1234',
  'sarah@designstudio.io': 'design99',
  'demo@client.app': 'demo',
};

// ─── Mock Clients ─────────────────────────────────────────────────────────────

final Map<String, Client> mockClients = {
  // ── Alex / TechCorp ──────────────────────────────────────────────────────
  'alex@techcorp.com': Client(
    id: 'c001',
    name: 'Alex Mercer',
    email: 'alex@techcorp.com',
    company: 'TechCorp Solutions',
    avatarInitials: 'AM',
    phone: '+1 (555) 234-5678',
    supportEmail: 'support@youragency.com',
    memberSince: DateTime(2023, 3, 15),
    projects: [
      // ── Project 1: ShopEasy (Mobile App) ─────────────────────────────────
      Project(
        id: 'p001',
        name: 'ShopEasy App',
        type: ProjectType.mobileApp,
        description: 'E-commerce mobile application for iOS & Android',
        accentColor: const Color(0xFF00D4FF),
        createdAt: DateTime(2023, 3, 20),
        credentials: [
          // App Store
          Credential(
            id: 'cr001',
            label: 'App Store Connect',
            type: CredentialType.appStore,
            fields: {
              'Apple ID': 'alex@techcorp.com',
              'Password': 'AppStore@2024!',
              'Team ID': 'ABCD1234EF',
              'Bundle ID': 'com.techcorp.shopeasy',
              'App Store Connect URL': 'https://appstoreconnect.apple.com',
            },
            expiryDate: DateTime.now().add(const Duration(days: 5)),
            appStoreLink: 'https://apps.apple.com/app/shopeasy/id1234567890',
            notes: 'Requires 2FA. Backup codes stored separately.',
          ),

          // Play Store
          Credential(
            id: 'cr002',
            label: 'Google Play Console',
            type: CredentialType.playStore,
            fields: {
              'Email': 'play.techcorp@gmail.com',
              'Password': 'Play\$tore2024',
              'Package Name': 'com.techcorp.shopeasy',
              'Developer Account': 'TechCorp Solutions',
              'Play Console URL': 'https://play.google.com/console',
            },
            expiryDate: DateTime.now().add(const Duration(days: 45)),
            playStoreLink:
                'https://play.google.com/store/apps/details?id=com.techcorp.shopeasy',
            notes: 'Annual developer fee auto-renews via Google Wallet.',
          ),

          // Twilio
          Credential(
            id: 'cr003',
            label: 'Twilio — SMS & OTP',
            type: CredentialType.twilio,
            fields: {
              'Account SID': 'DEMO_TWILIO_ACCOUNT_SID_GOES_HERE',
              'Auth Token': 'DEMO_TWILIO_AUTH_TOKEN_GOES_HERE',
              'Phone Number': '+15550001234',
              'API Key SID': 'DEMO_TWILIO_API_KEY_SID_GOES_HERE',
              'API Secret': 'DEMO_TWILIO_API_SECRET_GOES_HERE',
              'Console URL': 'https://console.twilio.com',
            },
            expiryDate: DateTime.now().add(const Duration(days: 120)),
            notes:
                'Balance auto-recharges at \$10. SMS used for OTP & order updates.',
          ),

          // Firebase
          Credential(
            id: 'cr004',
            label: 'Firebase (Push + Auth)',
            type: CredentialType.firebase,
            fields: {
              'API Key': 'DEMO_FIREBASE_API_KEY_GOES_HERE',
              'Project ID': 'shopeasy-prod',
              'Auth Domain': 'shopeasy-prod.firebaseapp.com',
              'Storage Bucket': 'shopeasy-prod.appspot.com',
              'Messaging Sender ID': '123456789012',
              'App ID (Android)': '1:123456789012:android:abc123',
              'App ID (iOS)': '1:123456789012:ios:def456',
              'Console URL': 'https://console.firebase.google.com',
            },
            notes:
                'Spark plan — 10K notifs/day free. FCM used for push notifications.',
          ),

          // MongoDB
          Credential(
            id: 'cr005',
            label: 'MongoDB Atlas',
            type: CredentialType.mongodb,
            fields: {
              'Email': 'db@techcorp.com',
              'Password': 'Atlas#Pass2024',
              'Cluster': 'Cluster0 (M10)',
              'Region': 'AWS us-east-1',
              'Connection URI':
                  'mongodb+srv://appuser:***@cluster0.xxxxx.mongodb.net/shopeasy',
              'DB Username': 'appuser',
              'DB Password': 'DbUserP@ss123',
              'Atlas URL': 'https://cloud.mongodb.com',
            },
            expiryDate: DateTime.now().add(const Duration(days: 90)),
            notes:
                'M10 cluster \$57/mo. IP whitelist: 0.0.0.0/0 (open — tighten before prod).',
          ),

          // AWS
          Credential(
            id: 'cr006',
            label: 'AWS (S3 + CloudFront)',
            type: CredentialType.aws,
            fields: {
              'Account ID': '123456789012',
              'Root Email': 'aws@techcorp.com',
              'Access Key ID': 'DEMO_AWS_ACCESS_KEY_ID_HERE',
              'Secret Access Key': 'wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY',
              'Region': 'us-east-1',
              'S3 Bucket': 'shopeasy-assets-prod',
              'CloudFront Domain': 'dxxxxxxx.cloudfront.net',
              'Console URL': 'https://console.aws.amazon.com',
            },
            expiryDate: DateTime.now().add(const Duration(days: 6)),
            notes:
                'Access keys rotate every 90 days. IAM user: shopeasy-s3-app.',
          ),
        ],
      ),

      // ── Project 2: TechCorp Dashboard (Web) ──────────────────────────────
      Project(
        id: 'p002',
        name: 'TechCorp Dashboard',
        type: ProjectType.webApp,
        description: 'Internal analytics & operations dashboard',
        accentColor: const Color(0xFFFFB020),
        createdAt: DateTime(2023, 8, 1),
        credentials: [
          // Domain + SSL
          Credential(
            id: 'cr007',
            label: 'Domain + SSL — techcorp-dash.com',
            type: CredentialType.domain,
            fields: {
              'Registrar': 'Namecheap',
              'Registrar Email': 'techcorp_admin',
              'Registrar Password': 'Domain#2024',
              'Domain': 'techcorp-dashboard.com',
              'SSL Provider': "Let's Encrypt",
              'Website URL': 'https://techcorp-dashboard.com',
            },
            expiryDate:
                DateTime.now().add(const Duration(days: -3)), // domain EXPIRED
            secondaryExpiryDate:
                DateTime.now().add(const Duration(days: 25)), // SSL soon
            secondaryExpiryLabel: 'SSL Certificate',
            notes: 'EXPIRED — renew immediately via Namecheap dashboard.',
          ),

          // Hostinger
          Credential(
            id: 'cr008',
            label: 'Hostinger — Web Hosting',
            type: CredentialType.hosting,
            fields: {
              'Email': 'hosting@techcorp.com',
              'Password': 'Host!ng3r2024',
              'Plan': 'Business Shared',
              'FTP Host': 'ftp.techcorp-dashboard.com',
              'FTP Username': 'u123456789',
              'FTP Password': 'ftpP@ss22',
              'hPanel URL': 'https://hpanel.hostinger.com',
              'Webmail URL': 'https://webmail.hostinger.com',
            },
            expiryDate: DateTime.now().add(const Duration(days: 22)),
            notes:
                'Annual plan. Renew before expiry to avoid 20% reinstatement fee.',
          ),

          // SendGrid
          Credential(
            id: 'cr009',
            label: 'SendGrid — Transactional Email',
            type: CredentialType.email,
            fields: {
              'API Key': 'DEMO_SENDGRID_API_KEY_GOES_HERE',
              'From Email': 'noreply@techcorp-dashboard.com',
              'Plan': 'Essentials 50K',
              'Dashboard URL': 'https://app.sendgrid.com',
            },
            expiryDate: DateTime.now().add(const Duration(days: 60)),
          ),
        ],
      ),
    ],
  ),

  // ── Sarah / Design Studio ─────────────────────────────────────────────────
  'sarah@designstudio.io': Client(
    id: 'c002',
    name: 'Sarah Chen',
    email: 'sarah@designstudio.io',
    company: 'Pixel & Stone Studio',
    avatarInitials: 'SC',
    phone: '+44 7700 900123',
    supportEmail: 'support@youragency.com',
    memberSince: DateTime(2024, 1, 10),
    projects: [
      Project(
        id: 'p003',
        name: 'Portfolio Site',
        type: ProjectType.webApp,
        description: 'Creative portfolio and client showcase website',
        accentColor: const Color(0xFFBF5AF2),
        createdAt: DateTime(2024, 1, 15),
        credentials: [
          Credential(
            id: 'cr010',
            label: 'Domain + SSL — pixelandstone.io',
            type: CredentialType.domain,
            fields: {
              'Registrar': 'GoDaddy',
              'Registrar Email': 'sarah.chen@gmail.com',
              'Registrar Password': 'GoDaddy2024!',
              'Domain': 'pixelandstone.io',
              'SSL Provider': 'Cloudflare',
              'Website URL': 'https://pixelandstone.io',
            },
            expiryDate: DateTime.now().add(const Duration(days: 200)),
            secondaryExpiryDate: DateTime.now().add(const Duration(days: 85)),
            secondaryExpiryLabel: 'SSL Certificate',
          ),
          Credential(
            id: 'cr011',
            label: 'Vercel — Hosting',
            type: CredentialType.hosting,
            fields: {
              'Email': 'sarah@designstudio.io',
              'Password': 'Vercel\$ecure1',
              'Team Slug': 'pixel-stone',
              'Dashboard URL': 'https://vercel.com/dashboard',
            },
          ),
          Credential(
            id: 'cr012',
            label: 'Stripe — Payment Gateway',
            type: CredentialType.payment,
            fields: {
              'Publishable Key': 'DEMO_STRIPE_PUBLISHABLE_KEY_HERE',
              'Secret Key': 'DEMO_STRIPE_SECRET_KEY_HERE',
              'Webhook Secret': 'DEMO_STRIPE_WEBHOOK_SECRET_HERE',
              'Dashboard URL': 'https://dashboard.stripe.com',
            },
            expiryDate: DateTime.now().add(const Duration(days: 14)),
            notes:
                'Live keys — handle with care. Webhook set up for /api/stripe-webhook.',
          ),
        ],
      ),
    ],
  ),

  // ── Demo User ─────────────────────────────────────────────────────────────
  'demo@client.app': Client(
    id: 'c003',
    name: 'Demo User',
    email: 'demo@client.app',
    company: 'Demo Company Inc.',
    avatarInitials: 'DU',
    phone: '+1 (555) 000-0000',
    supportEmail: 'support@youragency.com',
    memberSince: DateTime(2024, 6, 1),
    projects: [
      Project(
        id: 'p004',
        name: 'Demo App',
        type: ProjectType.both,
        description: 'Sample project with all credential types',
        accentColor: const Color(0xFF22C55E),
        createdAt: DateTime(2024, 6, 1),
        credentials: [
          Credential(
            id: 'cr013',
            label: 'App Store Connect',
            type: CredentialType.appStore,
            fields: {
              'Apple ID': 'demo@client.app',
              'Password': 'DemoAppStore1!',
              'Team ID': 'DEMO1234EF',
              'Bundle ID': 'com.demo.app',
            },
            appStoreLink: 'https://apps.apple.com/app/demo/id9999999999',
            expiryDate: DateTime.now().add(const Duration(days: 90)),
          ),
          Credential(
            id: 'cr014',
            label: 'Google Play Console',
            type: CredentialType.playStore,
            fields: {
              'Email': 'demo@client.app',
              'Package Name': 'com.demo.app',
            },
            playStoreLink:
                'https://play.google.com/store/apps/details?id=com.demo.app',
            expiryDate: DateTime.now().add(const Duration(days: 90)),
          ),
          Credential(
            id: 'cr015',
            label: 'MongoDB Atlas',
            type: CredentialType.mongodb,
            fields: {
              'Email': 'db@demo.app',
              'Password': 'DemoDb@2024',
              'Connection URI':
                  'mongodb+srv://demouser:***@demo.xxxxx.mongodb.net',
              'DB Username': 'demouser',
              'DB Password': 'DemoPass123',
              'Atlas URL': 'https://cloud.mongodb.com',
            },
            expiryDate: DateTime.now().add(const Duration(days: 365)),
            notes: 'Free M0 cluster for sandbox.',
          ),
        ],
      ),
    ],
  ),
};

// ─── Mock Alerts ──────────────────────────────────────────────────────────────

List<AppAlert> getMockAlerts(Client client) {
  final alerts = <AppAlert>[];
  for (final project in client.projects) {
    for (final cred in project.credentials) {
      if (cred.expiryStatus == ExpiryStatus.expired) {
        alerts.add(AppAlert(
          id: 'a_${cred.id}',
          title: '🚨 Expired: ${cred.label}',
          message:
              '${cred.label} in ${project.name} has expired. Renew immediately to avoid service disruption.',
          severity: ExpiryStatus.expired,
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
          projectId: project.id,
          credentialId: cred.id,
        ));
      } else if (cred.expiryStatus == ExpiryStatus.critical) {
        alerts.add(AppAlert(
          id: 'a_${cred.id}',
          title: '⚠️ Expiring Soon: ${cred.label}',
          message:
              '${cred.label} in ${project.name} expires in ${cred.daysUntilExpiry} days. Please renew.',
          severity: ExpiryStatus.critical,
          createdAt: DateTime.now().subtract(const Duration(hours: 1)),
          projectId: project.id,
          credentialId: cred.id,
        ));
      } else if (cred.expiryStatus == ExpiryStatus.expiringSoon) {
        alerts.add(AppAlert(
          id: 'a_${cred.id}',
          title: 'Renewal Reminder: ${cred.label}',
          message:
              '${cred.label} in ${project.name} expires in ${cred.daysUntilExpiry} days.',
          severity: ExpiryStatus.expiringSoon,
          createdAt: DateTime.now().subtract(const Duration(hours: 5)),
          projectId: project.id,
          credentialId: cred.id,
        ));
      }
    }
  }
  alerts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  return alerts;
}
