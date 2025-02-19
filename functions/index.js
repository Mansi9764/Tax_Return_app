const functions = require("firebase-functions");
const nodemailer = require("nodemailer");

// ✅ Load environment variables from Firebase
const gmailUser = functions.config().gmail.user;
const gmailPass = functions.config().gmail.pass;

// ✅ Configure Nodemailer with Gmail
const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: gmailUser,
    pass: gmailPass,
  },
});

// 📩 Cloud Function to Send Email
exports.sendPaymentReceipt = functions.https.onRequest(async (req, res) => {
  try {
    console.log("🔥 Incoming email request:", req.body);

    const { email, transactionId } = req.body;
    if (!email || !transactionId) {
      return res.status(400).json({ success: false, message: "Missing email or transaction ID" });
    }

    console.log(`✅ Sending email to: ${email} | Transaction ID: ${transactionId}`);

    const mailOptions = {
      from: gmailUser,
      to: email,
      subject: "Payment Confirmation",
      text: `Dear Customer,\n\nYour payment was successful.\nTransaction ID: ${transactionId}\n\nThank you!`,
    };

    await transporter.sendMail(mailOptions);
    console.log(`✅ Email successfully sent to ${email}`);

    return res.status(200).json({ success: true, message: "Email sent successfully!" });
  } catch (error) {
    console.error("❌ Error sending email:", error);
    return res.status(500).json({ success: false, message: error.toString() });
  }
});
