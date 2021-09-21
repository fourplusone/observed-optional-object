import Combine
import SwiftUI

/// A property wrapper that works like `ObservedObject`, but takes an optional object instead.
///
/// The `@ObservedObject` wrapper requires, that the observed object actually exists. In some cases
/// it's convenient to be able to observe an object which might be nil. This is where
/// `@ObservedOptionalObject` can be used.
///
/// ```swift
/// struct SomeView: View {
///     // Instead of
///     @ObservedObject var anObject: Model? // Won't work
///
///     // use
///     @ObservedOptionalObject var anObject: Model?
///
///     var body: some View {
///         HStack {
///             Text("Name")
///             if let name = anObject?.name {
///                 Text(name)
///             }
///         }
///     }
/// }
/// ```
@propertyWrapper public struct ObservedOptionalObject<T: ObservableObject>: DynamicProperty {
    private(set) public var wrappedValue: T?

    public init(wrappedValue: T?) {
        self.wrappedValue = wrappedValue

        let proxy = Proxy()
        self.proxy = proxy
        self.proxyObject = proxy
    }

    public mutating func update() {
        let proxy = self.proxy
        self.proxyMonitor = self.wrappedValue?.objectWillChange.sink { [weak proxy] _ in
            proxy?.objectWillChange.send()
        }
    }

    // - Private
    @State private var          proxy:        Proxy
    @ObservedObject private var proxyObject:  Proxy
    private var                 proxyMonitor: AnyCancellable?
    private class Proxy: ObservableObject {
    }

    // - Projection
    public var projectedValue: Wrapper {
        Wrapper( wrappedObject: wrappedValue )
    }

    @dynamicMemberLookup public struct Wrapper {
        let wrappedObject: T?

        /// Returns an optional binding to the resulting value of a given key path.
        ///
        /// - Parameter keyPath  : A key path to a specific resulting value.
        ///
        /// - Returns: A new binding.
        public subscript<Subject>(dynamicMember keyPath: ReferenceWritableKeyPath<T, Subject>) -> Binding<Subject>? {
            guard let wrappedObject = self.wrappedObject
            else { return nil }

            return Binding {
                wrappedObject[keyPath: keyPath]
            } set: { value in
                wrappedObject[keyPath: keyPath] = value
            }
        }
    }
}
