//
//  Modifiers.swift
//  SwiftCheck-iOS
//
//  Created by Robert Widmann on 1/29/15.
//  Copyright (c) 2015 CodaFi. All rights reserved.
//

import Swiftz

/// For types that either do not have a Printable instance or that wish to have no description to
/// print, Blind will create a default description for them.
public struct Blind<A : Arbitrary> : Arbitrary, Printable {
	public let getBlind : A
	
	public init(_ blind : A) {
		self.getBlind = blind
	}
	
	public var description : String {
		return "(*)"
	}
	
	private static func create(blind : A) -> Blind<A> {
		return Blind(blind)
	}
	
	public static func arbitrary() -> Gen<Blind<A>> {
		return Blind.create <^> A.arbitrary()
	}
	
	public static func shrink(bl : Blind<A>) -> [Blind<A>] {
		return Blind.create <^> A.shrink(bl.getBlind)
	}
}

public func == <T : protocol<Arbitrary, Equatable>>(lhs : Blind<T>, rhs : Blind<T>) -> Bool {
	return lhs.getBlind == rhs.getBlind
}

public func <^><A : Arbitrary, B : Arbitrary>(f: A -> B, ar : Blind<A>) -> Blind<B> {
	return Blind<B>(f(ar.getBlind))
}

/// Guarantees test cases for its underlying type will not be shrunk.
public struct Static<A : Arbitrary> : Arbitrary, Printable {
	public let getStatic : A
	
	public init(_ fixed : A) {
		self.getStatic = fixed
	}
	
	public var description : String {
		return "Static( \(self.getStatic) )"
	}
	
	private static func create(blind : A) -> Static<A> {
		return Static(blind)
	}
	
	public static func arbitrary() -> Gen<Static<A>> {
		return Static.create <^> A.arbitrary()
	}
	
	public static func shrink(bl : Static<A>) -> [Static<A>] {
		return []
	}
}

public func == <T : protocol<Arbitrary, Equatable>>(lhs : Static<T>, rhs : Static<T>) -> Bool {
	return lhs.getStatic == rhs.getStatic
}

public func <^><A : Arbitrary, B : Arbitrary>(f: A -> B, ar : Static<A>) -> Static<B> {
	return Static<B>(f(ar.getStatic))
}

/// Guarantees that every generated integer is greater than 0.
public struct Positive<A : protocol<Arbitrary, SignedNumberType>> : Arbitrary, Printable {
	public let getPositive : A
	
	public init(_ pos : A) {
		self.getPositive = pos
	}
	
	public var description : String {
		return "Positive( \(self.getPositive) )"
	}
	
	private static func create(blind : A) -> Positive<A> {
		return Positive(blind)
	}
	
	public static func arbitrary() -> Gen<Positive<A>> {
		return (Positive.create • abs) <^> A.arbitrary().suchThat(>0)
	}
	
	public static func shrink(bl : Positive<A>) -> [Positive<A>] {
		return A.shrink(bl.getPositive).filter(>0).map({ Positive($0) })
	}
}

public func == <T : protocol<Arbitrary, SignedNumberType>>(lhs : Positive<T>, rhs : Positive<T>) -> Bool {
	return lhs.getPositive == rhs.getPositive
}

public func <^><A : protocol<Arbitrary, SignedNumberType>, B : protocol<Arbitrary, SignedNumberType>>(f: A -> B, ar : Positive<A>) -> Positive<B> {
	return Positive<B>(f(ar.getPositive))
}

/// Guarantees that every generated integer is never 0.
public struct NonZero<A : protocol<Arbitrary, IntegerType>> : Arbitrary, Printable {
	public let getNonZero : A
	
	public init(_ non : A) {
		self.getNonZero = non
	}
	
	public var description : String {
		return "NonZero( \(self.getNonZero) )"
	}
	
	private static func create(blind : A) -> NonZero<A> {
		return NonZero(blind)
	}
	
	public static func arbitrary() -> Gen<NonZero<A>> {
		return NonZero.create <^> A.arbitrary().suchThat { $0 != 0 }
	}
	
	public static func shrink(bl : NonZero<A>) -> [NonZero<A>] {
		return A.shrink(bl.getNonZero).filter({ $0 != 0 }).map({ NonZero($0) })
	}
}

public func == <T : protocol<Arbitrary, IntegerType>>(lhs : NonZero<T>, rhs : NonZero<T>) -> Bool {
	return lhs.getNonZero == rhs.getNonZero
}

public func <^><A : protocol<Arbitrary, IntegerType>, B : protocol<Arbitrary, IntegerType>>(f: A -> B, ar : NonZero<A>) -> NonZero<B> {
	return NonZero<B>(f(ar.getNonZero))
}

/// Guarantees that every generated integer is greater than or equal to 0.
public struct NonNegative<A : protocol<Arbitrary, IntegerType>> : Arbitrary, Printable {
	public let getNonNegative : A
	
	public init(_ non : A) {
		self.getNonNegative = non
	}
	
	public var description : String {
		return "NonNegative( \(self.getNonNegative) )"
	}
	
	private static func create(blind : A) -> NonNegative<A> {
		return NonNegative(blind)
	}
	
	public static func arbitrary() -> Gen<NonNegative<A>> {
		return NonNegative.create <^> A.arbitrary().suchThat(>=0)
	}
	
	public static func shrink(bl : NonNegative<A>) -> [NonNegative<A>] {
		return A.shrink(bl.getNonNegative).filter(>=0).map({ NonNegative($0) })
	}
}

public func == <T : protocol<Arbitrary, IntegerType>>(lhs : NonNegative<T>, rhs : NonNegative<T>) -> Bool {
	return lhs.getNonNegative == rhs.getNonNegative
}

public func <^><A : protocol<Arbitrary, IntegerType>, B : protocol<Arbitrary, IntegerType>>(f: A -> B, ar : NonNegative<A>) -> NonNegative<B> {
	return NonNegative<B>(f(ar.getNonNegative))
}
