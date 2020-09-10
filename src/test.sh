#!/bin/bash

foo() {
  bar() {
    qux() {
      echo woo
    }
    qux
  }
  bar
}

foo
