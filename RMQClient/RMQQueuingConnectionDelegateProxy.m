// This source code is dual-licensed under the Mozilla Public License ("MPL"),
// version 2.0 and the Apache License ("ASL"), version 2.0.
//
// The ASL v2.0:
//
// ---------------------------------------------------------------------------
// Copyright 2017-2022 VMware, Inc. or its affiliates.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// ---------------------------------------------------------------------------
//
// The MPL v2.0:
//
// ---------------------------------------------------------------------------
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.
//
// Copyright (c) 2007-2022 VMware, Inc. or its affiliates.  All rights reserved.
//
// Alternatively, the contents of this file may be used under the terms
// of the Apache Standard license (the "ASL License"), in which case the
// provisions of the ASL License are applicable instead of those
// above. If you wish to allow use of your version of this file only
// under the terms of the ASL License and not to allow others to use
// your version of this file under the MPL, indicate your decision by
// deleting the provisions above and replace them with the notice and
// other provisions required by the ASL License. If you do not delete
// the provisions above, a recipient may use your version of this file
// under either the MPL or the ASL License.
// ---------------------------------------------------------------------------

#import "RMQQueuingConnectionDelegateProxy.h"

@interface RMQQueuingConnectionDelegateProxy ()
@property (nonatomic, weak, readwrite) id<RMQConnectionDelegate> delegate;
@property (nonatomic, readwrite) dispatch_queue_t queue;
@end

@implementation RMQQueuingConnectionDelegateProxy

- (instancetype)initWithDelegate:(id<RMQConnectionDelegate>)delegate
                           queue:(dispatch_queue_t)queue {
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.queue = queue;
    }
    return self;
}

- (void)connection:(RMQConnection *)connection disconnectedWithError:(NSError *)error {
    dispatch_async(self.queue, ^{
        if (self.delegate != nil) {
            [self.delegate connection:connection disconnectedWithError:error];
        }
    });
}

- (void)connection:(RMQConnection *)connection failedToConnectWithError:(NSError *)error {
    dispatch_async(self.queue, ^{
        if (self.delegate != nil) {
            [self.delegate connection:connection failedToConnectWithError:error];
        }
    });
}

- (void)channel:(id<RMQChannel>)channel error:(NSError *)error {
    dispatch_async(self.queue, ^{
        if (self.delegate != nil) {
            [self.delegate channel:channel error:error];
        }
    });
}

- (void)willStartRecoveryWithConnection:(RMQConnection *)connection {
    dispatch_async(self.queue, ^{
        if (self.delegate != nil) {
            [self.delegate willStartRecoveryWithConnection:connection];
        }
    });
}

- (void)startingRecoveryWithConnection:(RMQConnection *)connection {
    dispatch_async(self.queue, ^{
        if (self.delegate != nil) {
            [self.delegate startingRecoveryWithConnection:connection];
        }
    });
}

- (void)recoveredConnection:(RMQConnection *)connection {
    dispatch_async(self.queue, ^{
        if (self.delegate != nil) {
            [self.delegate recoveredConnection:connection];
        }
    });
}

@end
