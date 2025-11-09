// =====================================================
// RESET DATABASE USING PRISMA
// =====================================================
// No psql needed - uses Prisma directly

const { PrismaClient } = require('@prisma/client');
const readline = require('readline');

const prisma = new PrismaClient();

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

console.log('\n==========================================');
console.log('  OneFlow Database Reset');
console.log('==========================================\n');
console.log('⚠️  WARNING: This will DELETE ALL DATA!\n');

rl.question('Are you sure you want to continue? (Y/N): ', async (answer) => {
  if (answer.toUpperCase() !== 'Y') {
    console.log('\nReset cancelled.\n');
    rl.close();
    process.exit(0);
  }

  console.log('\nDeleting all data...\n');

  try {
    // Delete in correct order (respecting foreign keys)
    await prisma.verificationToken.deleteMany({});
    console.log('✓ Deleted VerificationTokens');
    
    await prisma.session.deleteMany({});
    console.log('✓ Deleted Sessions');
    
    await prisma.account.deleteMany({});
    console.log('✓ Deleted Accounts');
    
    await prisma.purchaseOrderActivity.deleteMany({});
    console.log('✓ Deleted PurchaseOrderActivities');
    
    await prisma.vendorBillLine.deleteMany({});
    console.log('✓ Deleted VendorBillLines');
    
    await prisma.invoiceLine.deleteMany({});
    console.log('✓ Deleted InvoiceLines');
    
    await prisma.purchaseOrderLine.deleteMany({});
    console.log('✓ Deleted PurchaseOrderLines');
    
    await prisma.salesOrderLine.deleteMany({});
    console.log('✓ Deleted SalesOrderLines');
    
    await prisma.payment.deleteMany({});
    console.log('✓ Deleted Payments');
    
    await prisma.attachment.deleteMany({});
    console.log('✓ Deleted Attachments');
    
    await prisma.taskComment.deleteMany({});
    console.log('✓ Deleted TaskComments');
    
    await prisma.timesheet.deleteMany({});
    console.log('✓ Deleted Timesheets');
    
    await prisma.task.deleteMany({});
    console.log('✓ Deleted Tasks');
    
    await prisma.projectMember.deleteMany({});
    console.log('✓ Deleted ProjectMembers');
    
    await prisma.projectManager.deleteMany({});
    console.log('✓ Deleted ProjectManagers');
    
    await prisma.expense.deleteMany({});
    console.log('✓ Deleted Expenses');
    
    await prisma.vendorBill.deleteMany({});
    console.log('✓ Deleted VendorBills');
    
    await prisma.customerInvoice.deleteMany({});
    console.log('✓ Deleted CustomerInvoices');
    
    await prisma.purchaseOrder.deleteMany({});
    console.log('✓ Deleted PurchaseOrders');
    
    await prisma.salesOrder.deleteMany({});
    console.log('✓ Deleted SalesOrders');
    
    await prisma.project.deleteMany({});
    console.log('✓ Deleted Projects');
    
    await prisma.product.deleteMany({});
    console.log('✓ Deleted Products');
    
    await prisma.partner.deleteMany({});
    console.log('✓ Deleted Partners');
    
    await prisma.user.deleteMany({});
    console.log('✓ Deleted Users');

    console.log('\n==========================================');
    console.log('✓ SUCCESS! Database reset complete!');
    console.log('==========================================\n');
    console.log('Next steps:');
    console.log('1. npm run dev');
    console.log('2. Sign up at http://localhost:3000/login');
    console.log('3. Run this in Prisma Studio to make yourself admin:');
    console.log('   npx prisma studio');
    console.log('   Then update your user role to ADMIN\n');
    console.log('Or run this SQL:');
    console.log('   UPDATE "User" SET role = \'ADMIN\' WHERE email = \'your@email.com\';\n');

  } catch (error) {
    console.error('\n✗ Error resetting database:', error.message);
    console.error('\nFull error:', error);
  } finally {
    await prisma.$disconnect();
    rl.close();
  }
});
