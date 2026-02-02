export const confirmationTemp = (code) => `<!--
* This email was built using Tabular.
* For more information, visit https://tabular.email
-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" 
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head>
<meta charset="UTF-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>Email Verification</title>

<!--[if !mso]>-->
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@500;600;700&display=swap" rel="stylesheet" />
<!--<![endif]-->

<style>
body {
  margin: 0;
  padding: 0;
  background-color: #F9F9F9;
  font-family: Inter, Arial, sans-serif;
}
</style>
</head>

<body>
<table width="100%" cellpadding="0" cellspacing="0" bgcolor="#F9F9F9">
<tr>
<td align="center" style="padding:70px 0;">

<table width="400" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF" 
style="border-radius:20px;border:1px solid #CECECE;padding:50px 40px 40px;">

<!-- Logo -->
<tr>
<td align="center">
<img src="https://afd3df0c-4b84-4fa2-a984-45f5c87adbd2.b-cdn.net/e/c750694d-9c75-49b9-affc-8106d9d65eeb/968fc7e3-beef-4d22-a095-ae0f1fc1a6e4.png"
width="60" height="60" alt="YallaDo Logo" />
</td>
</tr>

<tr><td height="40"></td></tr>

<!-- Title -->
<tr>
<td align="left" style="font-size:24px;font-weight:600;color:#111;">
Please verify your email 😀
</td>
</tr>

<tr><td height="17"></td></tr>

<!-- Description -->
<tr>
<td align="center" style="font-size:15px;line-height:22px;color:#424040;">
To use YallaDo, please enter the verification code below in the app.
This code helps us confirm your email and keep your account secure.
</td>
</tr>

<tr><td height="40"></td></tr>

<!-- CODE BOX -->
<tr>
<td align="center">
<table cellpadding="0" cellspacing="0" width="100%">
<tr>
<td align="center" 
style="
background-color:#F2F4FF;
border:1px dashed #0057FF;
border-radius:10px;
padding:16px;
font-size:26px;
font-weight:700;
letter-spacing:6px;
color:#0057FF;">
${code}
</td>
</tr>
</table>
</td>
</tr>

<tr><td height="12"></td></tr>

<!-- Code note -->
<tr>
<td align="center" style="font-size:13px;color:#777;">
This code will expire in 10 minutes.
</td>
</tr>

<tr><td height="40"></td></tr>

<!-- Info -->
<tr>
<td align="center" style="font-size:14px;line-height:22px;color:#424040;">
You're receiving this email because you have an account in YallaDo.
If you did not request this, please ignore this email.
</td>
</tr>

<tr><td height="30"></td></tr>

<!-- Footer -->
<tr>
<td align="center" style="
background-color:#F2EFF3;
border-radius:8px;
padding:20px 30px;
font-size:12px;
line-height:18px;
color:#84828E;">
© 2026 YallaDo. All rights reserved.<br/>
YallaDo is a task and family management platform designed to help parents
and children stay organized and connected.<br/>
This email was sent automatically. Please do not reply.
</td>
</tr>

</table>
</td>
</tr>
</table>

</body>
</html>`;

export const resetPasswordTemp = (code) => `<!--
* This email was built using Tabular.
* For more information, visit https://tabular.email
-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" 
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head>
<meta charset="UTF-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>Reset Password</title>

<!--[if !mso]>-->
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@500;600;700&display=swap" rel="stylesheet" />
<!--<![endif]-->

<style>
body {
  margin: 0;
  padding: 0;
  background-color: #F9F9F9;
  font-family: Inter, Arial, sans-serif;
}
</style>
</head>

<body>
<table width="100%" cellpadding="0" cellspacing="0" bgcolor="#F9F9F9">
<tr>
<td align="center" style="padding:70px 0;">

<table width="400" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF" 
style="border-radius:20px;border:1px solid #CECECE;padding:50px 40px 40px;">

<!-- Logo -->
<tr>
<td align="center">
<img src="https://afd3df0c-4b84-4fa2-a984-45f5c87adbd2.b-cdn.net/e/c750694d-9c75-49b9-affc-8106d9d65eeb/968fc7e3-beef-4d22-a095-ae0f1fc1a6e4.png"
width="60" height="60" alt="YallaDo Logo" />
</td>
</tr>

<tr><td height="40"></td></tr>

<!-- Title -->
<tr>
<td align="left" style="font-size:24px;font-weight:600;color:#111;">
Reset your password 🔐
</td>
</tr>

<tr><td height="17"></td></tr>

<!-- Description -->
<tr>
<td align="center" style="font-size:15px;line-height:22px;color:#424040;">
We received a request to reset your YallaDo account password.
Please enter the verification code below to continue.
</td>
</tr>

<tr><td height="40"></td></tr>

<!-- CODE BOX -->
<tr>
<td align="center">
<table cellpadding="0" cellspacing="0" width="100%">
<tr>
<td align="center" 
style="
background-color:#F2F4FF;
border:1px dashed #0057FF;
border-radius:10px;
padding:16px;
font-size:26px;
font-weight:700;
letter-spacing:6px;
color:#0057FF;">
${code}
</td>
</tr>
</table>
</td>
</tr>

<tr><td height="12"></td></tr>

<!-- Code note -->
<tr>
<td align="center" style="font-size:13px;color:#777;">
This code will expire in 10 minutes.
</td>
</tr>

<tr><td height="40"></td></tr>

<!-- Info -->
<tr>
<td align="center" style="font-size:14px;line-height:22px;color:#424040;">
If you did not request a password reset, please ignore this email.
Your account will remain secure.
</td>
</tr>

<tr><td height="30"></td></tr>

<!-- Footer -->
<tr>
<td align="center" style="
background-color:#F2EFF3;
border-radius:8px;
padding:20px 30px;
font-size:12px;
line-height:18px;
color:#84828E;">
© 2026 YallaDo. All rights reserved.<br/>
YallaDo is a task and family management platform designed to help parents
and children stay organized and connected.<br/>
This email was sent automatically. Please do not reply.
</td>
</tr>

</table>
</td>
</tr>
</table>

</body>
</html>`;
