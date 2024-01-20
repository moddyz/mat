#pragma once

/// \file type_name.h

#include <string_view>

namespace mat
{

/// Utility for extracing the string name of a type \p T.
///
/// From:
/// https://stackoverflow.com/questions/81870/is-it-possible-to-print-a-variables-type-in-standard-c
///
/// \tparam T the type to extract the string name from.
///
/// \return string name of the type.
template < typename T >
constexpr std::string_view type_name()
{
    std::string_view name, prefix, suffix;
#ifdef __clang__
    name   = __PRETTY_FUNCTION__;
    prefix = "std::string_view mat::type_name() [T = ";
    suffix = "]";
#elif defined( __GNUC__ )
    name   = __PRETTY_FUNCTION__;
    prefix = "constexpr std::string_view mat::type_name() [with T = ";
    suffix = "; std::string_view = std::basic_string_view<char>]";
#elif defined( _MSC_VER )
    name   = __FUNCSIG__;
    prefix = "class std::basic_string_view<char,struct std::char_traits<char> > __cdecl mat::type_name<";
    suffix = ">(void)";
#endif
    name.remove_prefix( prefix.size() );
    name.remove_suffix( suffix.size() );
    return name;
}

} // namespace mat
