# Security Policy

## Reporting a Vulnerability

If you discover a security vulnerability, please **do not** open a public GitHub
issue.

Instead, report it privately to the maintainer through either of these channels:

* Element / Matrix direct message: [`@cogina.solutions:matrix.org`](https://matrix.to/#/@cogina.solutions:matrix.org)
* Email: [owldevs@proton.me](mailto:owldevs@proton.me)

Please include:

* Description of the vulnerability
* Steps to reproduce
* Potential impact
* Proof of concept, if available

We will make a reasonable effort to acknowledge reports promptly and investigate
valid security concerns.

## Responsible Disclosure

Please do not publicly disclose security vulnerabilities until the issue has been
reviewed and a fix has been released. Responsible disclosure helps protect users
and infrastructure while remediation is underway.

## Scope

Examples of vulnerabilities that may be considered in scope:

* Authentication or authorization bypass
* Sensitive data exposure
* Remote code execution
* Server-side request forgery (SSRF)
* Dependency vulnerabilities with meaningful impact
* Infrastructure or API security issues

Examples generally considered out of scope:

* Missing security headers with no practical impact
* Rate limiting recommendations
* Theoretical vulnerabilities without a reproducible exploit
* Issues in third-party services outside of TaoPulse control

## Supported Versions

Security fixes are generally applied to the latest maintained version of the
project.

## Security Best Practices

Contributors should:

* Never commit secrets, API keys, or credentials.
* Use environment variables for sensitive configuration.
* Keep dependencies reasonably up to date.
* Review external contributions before merging.
* Follow the principle of least privilege when accessing infrastructure.

## Data Sources

TaoPulse may aggregate information from public APIs, repositories, and community
resources across the Bittensor ecosystem. Contributors should avoid collecting,
storing, or exposing private credentials, personal information, or restricted
content when developing data ingestion systems.
