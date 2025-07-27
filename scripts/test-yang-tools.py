#!/usr/bin/env python3
"""
Test script to check YANG tool availability and functionality.
Run this after setting up your development environment.
"""

import sys
import subprocess
import importlib.util


def check_command(cmd, name):
    """Check if a command-line tool is available."""
    try:
        result = subprocess.run([cmd, '--version'], 
                              capture_output=True, text=True, timeout=10)
        if result.returncode == 0:
            version = result.stdout.strip() or result.stderr.strip()
            print(f"✅ {name}: {version}")
            return True
        else:
            print(f"❌ {name}: command failed")
            return False
    except FileNotFoundError:
        print(f"❌ {name}: not found")
        return False
    except subprocess.TimeoutExpired:
        print(f"⚠️  {name}: command timeout")
        return False
    except Exception as e:
        print(f"❌ {name}: error - {e}")
        return False


def check_python_package(package, name=None):
    """Check if a Python package is available."""
    if name is None:
        name = package
    
    try:
        spec = importlib.util.find_spec(package)
        if spec is not None:
            try:
                module = importlib.import_module(package)
                version = getattr(module, '__version__', 'unknown version')
                print(f"✅ {name}: {version}")
                return True
            except Exception as e:
                print(f"⚠️  {name}: import error - {e}")
                return False
        else:
            print(f"❌ {name}: not installed")
            return False
    except Exception as e:
        print(f"❌ {name}: error - {e}")
        return False


def test_pyang_functionality():
    """Test basic pyang functionality."""
    try:
        import pyang
        from pyang import repository
        from pyang import context
        
        print("🧪 Testing pyang functionality...")
        ctx = context.Context(repository.FileRepository())
        print("✅ pyang: basic context creation works")
        return True
    except Exception as e:
        print(f"❌ pyang: functionality test failed - {e}")
        return False


def test_libyang_functionality():
    """Test basic libyang functionality."""
    try:
        import libyang
        print("🧪 Testing libyang functionality...")
        ctx = libyang.Context()
        print("✅ libyang: basic context creation works")
        ctx.destroy()
        return True
    except ImportError:
        print("ℹ️  libyang: Python bindings not available (optional)")
        return False
    except Exception as e:
        print(f"❌ libyang: functionality test failed - {e}")
        return False


def main():
    """Main test function."""
    print("🔍 YANG Tools Availability Check")
    print("=" * 40)
    
    # Check Python version
    python_version = f"{sys.version_info.major}.{sys.version_info.minor}.{sys.version_info.micro}"
    print(f"🐍 Python: {python_version}")
    
    print("\n📦 Command-line Tools:")
    pyang_cmd = check_command('pyang', 'pyang')
    yanglint_cmd = check_command('yanglint', 'yanglint')
    
    print("\n📚 Python Packages:")
    pyang_pkg = check_python_package('pyang', 'pyang')
    yangson_pkg = check_python_package('yangson', 'yangson')
    pyangbind_pkg = check_python_package('pyangbind', 'pyangbind')
    libyang_pkg = check_python_package('libyang', 'libyang Python bindings')
    
    print("\n🧪 Functionality Tests:")
    pyang_works = test_pyang_functionality() if pyang_pkg else False
    libyang_works = test_libyang_functionality() if libyang_pkg else None
    
    print("\n📊 Summary:")
    print(f"Core YANG validation: {'✅ Ready' if pyang_works else '❌ Not ready'}")
    print(f"Extended libyang features: {'✅ Available' if libyang_works else 'ℹ️  Optional (not installed)'}")
    
    if not pyang_works:
        print("\n❗ Issue: Core YANG tools not working properly")
        print("   Try: pip install -r requirements-dev.txt")
        return 1
    
    if yanglint_cmd and not libyang_pkg:
        print("\nℹ️  Tip: You have yanglint but not libyang Python bindings")
        print("   Try: pip install libyang")
        print("   (requires system libyang - see YANG_TOOLS.md)")
    
    print("\n🎉 YANG tools check complete!")
    return 0


if __name__ == '__main__':
    sys.exit(main())
