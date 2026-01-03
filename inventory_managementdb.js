
// Load environment variables
require('dotenv').config();

const mongoose = require('mongoose');


// Connect to MongoDB
mongoose
  .connect(process.env.MONGODB_URI)
  .then(() => {
    console.log('MongoDB connected successfully');
  })
  .catch((err) => {
    console.error('MongoDB connection error:', err);
  });


// SCHEMAS


// Admin Schema
const adminSchema = new mongoose.Schema(
  {
    admin_name: {
      type: String,
      required: true,
    },
  },
  { timestamps: true }
);

// User Schema
const userSchema = new mongoose.Schema(
  {
    name: {
      type: String,
      required: true,
    },
    email: {
      type: String,
      required: true,
      unique: true,
    },
    role: {
      type: String,
      enum: ['ADMIN', 'USER'],
      required: true,
    },
  },
  { timestamps: true }
);

// Category Schema
const categorySchema = new mongoose.Schema(
  {
    category_name: {
      type: String,
      required: true,
    },
  },
  { timestamps: true }
);

// Item Schema
const itemSchema = new mongoose.Schema(
  {
    name: {
      type: String,
      required: true,
    },
    price: {
      type: Number,
      required: true,
    },
    size: {
      type: String,
      enum: ['SMALL', 'MEDIUM', 'LARGE'],
      required: true,
    },
    description: String,
    category_id: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Category',
      required: true,
    },
    admin_id: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Admin',
    },
  },
  { timestamps: true }
);

// Order Schema
const orderSchema = new mongoose.Schema(
  {
    user_id: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: true,
    },
    status: {
      type: String,
      enum: ['PENDING', 'APPROVED', 'REJECTED'],
      default: 'PENDING',
    },
    approved_by: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Admin',
    },
  },
  { timestamps: true }
);

// Order Items Schema
const orderItemSchema = new mongoose.Schema(
  {
    order_id: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Order',
      required: true,
    },
    item_id: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Item',
      required: true,
    },
    quantity: {
      type: Number,
      required: true,
    },
  },
  { timestamps: true }
);


// MODELS
const Admin = mongoose.model('Admin', adminSchema);
const User = mongoose.model('User', userSchema);
const Category = mongoose.model('Category', categorySchema);
const Item = mongoose.model('Item', itemSchema);
const Order = mongoose.model('Order', orderSchema);
const OrderItem = mongoose.model('OrderItem', orderItemSchema);


// SAMPLE INSERT DATA

async function runTest() {
  try {
    const admin = await Admin.create({ admin_name: 'Main Admin' });

    const user = await User.create({
      name: 'Regular User',
      email: 'user@company.com',
      role: 'USER',
    });

    const category = await Category.create({
      category_name: 'Electronics',
    });

    const item = await Item.create({
      name: 'Laptop',
      price: 1500,
      size: 'LARGE',
      description: 'Company laptop',
      category_id: category._id,
      admin_id: admin._id,
    });

    const order = await Order.create({
      user_id: user._id,
    });

    await OrderItem.create({
      order_id: order._id,
      item_id: item._id,
      quantity: 1,
    });

    console.log('Sample data inserted successfully');
  } catch (error) {
    console.error(error);
  }
}


