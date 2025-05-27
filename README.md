# 🧵 Thread Color Conversion Tool

> A professional Ruby on Rails application that converts embroidery thread colors between 12 different brands with 400+ color mappings.

[![Ruby](https://img.shields.io/badge/Ruby-3.3.8-red.svg)](https://ruby-lang.org)
[![Rails](https://img.shields.io/badge/Rails-8.0.2-red.svg)](https://rubyonrails.org)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-15+-blue.svg)](https://postgresql.org)

**[🔗 Live Demo](https://embroidery-thread-converter.onrender.com)** | **[📧 Contact Me](mailto:raven.wills@gmail.com)**

---

## 🎯 Overview

This thread conversion tool solves a real problem for embroidery enthusiasts who need to convert thread colors between different manufacturers. Built with Ruby on Rails 8, it features a clean interface, flexible input parsing, and comprehensive brand coverage.

### ✨ Key Features

- 🔄 **Universal Conversion**: Convert between any of 12 thread brands
- 📊 **400+ Color Database**: Comprehensive thread color mappings
- 🎨 **Flexible Input**: Supports comma, space, and line-separated thread numbers
- 💻 **Responsive Design**: Beautiful interface that works on all devices
- ⚡ **Fast Performance**: Indexed database queries for instant results
- 🛠️ **Professional Architecture**: Clean MVC design following Rails conventions

### 🏢 Supported Brands

- **DMC** - The world's leading embroidery thread manufacturer
- **Anchor** - Popular cross-stitch and embroidery threads
- **Madeira** - Premium embroidery and quilting threads
- **Cosmo** - High-quality Japanese embroidery threads
- **Olympus** - Traditional Japanese thread manufacturer
- **JP Coats** - Classic American thread brand
- **Lecien** - Japanese specialty threads
- **Sullivans** - Quilting and embroidery supplies
- **Aurifil** - Italian cotton thread manufacturer
- **Weeks** - Hand-dyed specialty threads
- **Gentle Art** - Artisan hand-dyed threads
- **Classic Colorworks** - Premium hand-dyed floss

---

## 🚀 Live Demo

**Try it now:** [Thread Converter Live Demo](https://embroidery-thread-converter.onrender.com)

### Quick Test:
1. Convert **FROM:** DMC **TO:** Anchor
2. Enter thread numbers: `208, 209, 210, 320`
3. See instant conversions!

---

## 💻 Technical Implementation

### Architecture Highlights

- **Ruby on Rails 8** with modern conventions
- **PostgreSQL** database with optimized indexing
- **Nokogiri HTML parsing** for data extraction
- **Responsive CSS** with gradient design
- **Turbo & Stimulus** for enhanced UX

### Key Technical Decisions

#### 🗄️ **Database Design**
```ruby
# Optimized for fast lookups across all brands
add_index :thread_colors, :dmc, unique: true
add_index :thread_colors, :anchor
add_index :thread_colors, :madeira
# ... indexes for all 12 brands
```

#### 🔍 **Smart Search Logic**
```ruby
# Handles multiple thread values like "111/110"
def self.find_by_brand_and_number(brand, number)
  where("#{brand} = ? OR #{brand} LIKE ? OR #{brand} LIKE ? OR #{brand} LIKE ?",
        number, "#{number}/%", "%/#{number}", "%/#{number}/%").first
end
```

#### 📝 **Flexible Input Parsing**
```ruby
# Accepts any format: "208, 209, 210" or "208 209 210" or line-separated
def self.parse_thread_numbers(input)
  input.strip.split(/[,\n\r\s]+/).map(&:strip).reject(&:blank?)
end
```

---

## 🛠️ Development Process

### 1. Data Extraction Challenge
- **Problem**: Thread conversion data was trapped in HTML tables on a website
- **Solution**: Built custom Nokogiri parser to extract 400+ thread colors
- **Result**: Clean, structured data ready for Rails integration

### 2. Database Architecture
- **Challenge**: Supporting conversions between any two brands efficiently
- **Solution**: Normalized table structure with strategic indexing
- **Performance**: Sub-millisecond query times even with complex lookups

### 3. User Experience Focus
- **Flexible Input**: Users can paste thread lists in any format
- **Clear Results**: Easy-to-read conversion tables with status indicators
- **Responsive Design**: Works perfectly on mobile and desktop

---

## 🚀 Getting Started

### Prerequisites
- Ruby 3.3.8+
- Rails 8.0.2+
- PostgreSQL 15+

### Installation

```bash
# Clone the repository
git clone https://github.com/raven-wills/embroidery-thread-converter.git
cd embroidery-thread-converter

# Install dependencies
bundle install

# Setup database
rails db:create
rails db:migrate
rails db:seed

# Start the server
rails server
```

Visit `http://localhost:3000` and start converting!

### Sample Data Included
The app comes with 400+ pre-loaded thread colors for immediate testing.

---

## 🎨 Screenshots

### Main Interface
![Thread Converter Interface](screenshots/main-interface.png)

### Conversion Results
![Conversion Results](screenshots/conversion-results.png)

### Mobile Responsive
![Mobile View](screenshots/mobile-view.png)

---

## 🔮 Future Enhancements

This application is architected for easy expansion:

### 🎨 **Visual Features**
- [ ] Color swatch images with Active Storage
- [ ] Visual color picker interface
- [ ] Color similarity matching algorithms

### 👥 **User Features**
- [ ] User accounts with Devise authentication
- [ ] Save favorite thread combinations
- [ ] Export results to PDF/Excel

### 📱 **Platform Expansion**
- [ ] JSON API for mobile app integration
- [ ] React Native mobile app
- [ ] Browser extension for quick conversions

### 🔧 **Admin Features**
- [ ] Admin interface for managing thread data
- [ ] Bulk import/export capabilities
- [ ] Analytics dashboard

---

## 🧪 Testing

```bash
# Run the test suite
bundle exec rspec

# Run with coverage
bundle exec rspec --format documentation
```

---

## 🚀 Deployment

### Render Deployment
```bash
# Connect your GitHub repository to Render
# Configure environment variables:
RAILS_ENV=production
SECRET_KEY_BASE=your_secret_key
RAILS_MASTER_KEY=your_master_key

# Deploy automatically on git push
git push origin main
```

### Environment Variables
```bash
# Production settings
RAILS_ENV=production
DATABASE_URL=your_postgresql_url
SECRET_KEY_BASE=your_secret_key
RAILS_MASTER_KEY=your_master_key
```

---

## 👨‍💻 About the Developer

Hi! I'm Raven, a Ruby on Rails developer passionate about building tools that solve real-world problems. This project demonstrates my ability to:

- **Extract and structure data** from complex sources
- **Design efficient database schemas** for performance
- **Build beautiful, responsive interfaces** that users love
- **Write clean, maintainable code** following best practices
- **Deploy professional applications** ready for production

### 🔗 Let's Connect!
- **LinkedIn**: [linkedin.com/in/raven-wills](https://www.linkedin.com/in/raven-wills/)
- **Email**: [raven.wills@gmail.com](mailto:raven.wills@gmail.com)

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- Thread color data sourced from embroidery manufacturer websites
- Built with the amazing Ruby on Rails framework
- UI inspired by modern design principles
- Special thanks to the embroidery community for inspiration

---

**⭐ If you find this project useful, please give it a star!**

*Built with ❤️ and Ruby on Rails*
