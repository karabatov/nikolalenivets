//
//  NSString+Ordinal.m
//  NikolaLenivets
//
//  Created by Yuri Karabatov on 15.07.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NSString+Ordinal.h"

@implementation NSString (Ordinal)


+ (NSString *)ordinalRepresentationWithNumber:(NSInteger)ordinal
{
    if (![[NSLocale currentLocale].localeIdentifier isEqualToString:@"ru_RU"]) {
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterSpellOutStyle];

        NSString *ordinalStr = [formatter stringFromNumber:@(ordinal)];
        
        return ordinalStr;
    }

    switch (ordinal) {
        case 0:
            return @"нулевой";
            break;

        case 1:
            return @"первый";
            break;

        case 2:
            return @"второй";
            break;

        case 3:
            return @"третий";
            break;

        case 4:
            return @"четвертый";
            break;

        case 5:
            return @"пятый";
            break;

        case 6:
            return @"шестой";
            break;

        case 7:
            return @"седьмой";
            break;

        case 8:
            return @"восьмой";
            break;

        case 9:
            return @"девятый";
            break;

        case 10:
            return @"десятый";
            break;

        case 11:
            return @"одиннадцатый";
            break;

        case 12:
            return @"двенадцатый";
            break;

        case 13:
            return @"тринадцатый";
            break;

        case 14:
            return @"четырнадцатый";
            break;

        case 15:
            return @"пятнадцатый";
            break;

        case 16:
            return @"шестнадцатый";
            break;

        case 17:
            return @"семнадцатый";
            break;

        case 18:
            return @"восемнадцатый";
            break;

        case 19:
            return @"девятнадцатый";
            break;

        case 20:
            return @"двадцатый";
            break;

        case 21:
        case 22:
        case 23:
        case 24:
        case 25:
        case 26:
        case 27:
        case 28:
        case 29:
            return [NSString stringWithFormat:@"%@ %@", @"двадцать", [NSString ordinalRepresentationWithNumber:ordinal - 20]];
            break;

        case 30:
            return @"тридцатый";
            break;

        case 31:
        case 32:
        case 33:
        case 34:
        case 35:
        case 36:
        case 37:
        case 38:
        case 39:
            return [NSString stringWithFormat:@"%@ %@", @"тридцать", [NSString ordinalRepresentationWithNumber:ordinal - 30]];
            break;

        case 40:
            return @"сороковой";
            break;

        case 41:
        case 42:
        case 43:
        case 44:
        case 45:
        case 46:
        case 47:
        case 48:
        case 49:
            return [NSString stringWithFormat:@"%@ %@", @"сорок", [NSString ordinalRepresentationWithNumber:ordinal - 40]];
            break;

        case 50:
            return @"пятидесятый";
            break;

        case 51:
        case 52:
        case 53:
        case 54:
        case 55:
        case 56:
        case 57:
        case 58:
        case 59:
            return [NSString stringWithFormat:@"%@ %@", @"пятьдесят", [NSString ordinalRepresentationWithNumber:ordinal - 50]];
            break;

        case 60:
            return @"шестидесятый";
            break;

        case 61:
        case 62:
        case 63:
        case 64:
        case 65:
        case 66:
        case 67:
        case 68:
        case 69:
            return [NSString stringWithFormat:@"%@ %@", @"шестьдесят", [NSString ordinalRepresentationWithNumber:ordinal - 60]];
            break;

        case 70:
            return @"семидесятый";
            break;

        case 71:
        case 72:
        case 73:
        case 74:
        case 75:
        case 76:
        case 77:
        case 78:
        case 79:
            return [NSString stringWithFormat:@"%@ %@", @"семьдесят", [NSString ordinalRepresentationWithNumber:ordinal - 70]];
            break;

        case 80:
            return @"восьмидесятый";
            break;

        case 81:
        case 82:
        case 83:
        case 84:
        case 85:
        case 86:
        case 87:
        case 88:
        case 89:
            return [NSString stringWithFormat:@"%@ %@", @"восемьдесят", [NSString ordinalRepresentationWithNumber:ordinal - 80]];
            break;

        case 90:
            return @"девяностый";
            break;

        case 91:
        case 92:
        case 93:
        case 94:
        case 95:
        case 96:
        case 97:
        case 98:
        case 99:
            return [NSString stringWithFormat:@"%@ %@", @"девяносто", [NSString ordinalRepresentationWithNumber:ordinal - 90]];
            break;

        case 100:
            return @"сотый";
            break;

        case 101:
        case 102:
        case 103:
        case 104:
        case 105:
        case 106:
        case 107:
        case 108:
        case 109:
        case 110:
        case 111:
        case 112:
        case 113:
        case 114:
        case 115:
        case 116:
        case 117:
        case 118:
        case 119:
        case 120:
        case 121:
        case 122:
        case 123:
        case 124:
        case 125:
        case 126:
        case 127:
        case 128:
        case 129:
        case 130:
        case 131:
        case 132:
        case 133:
        case 134:
        case 135:
        case 136:
        case 137:
        case 138:
        case 139:
        case 140:
        case 141:
        case 142:
        case 143:
        case 144:
        case 145:
        case 146:
        case 147:
        case 148:
        case 149:
        case 150:
        case 151:
        case 152:
        case 153:
        case 154:
        case 155:
        case 156:
        case 157:
        case 158:
        case 159:
        case 160:
        case 161:
        case 162:
        case 163:
        case 164:
        case 165:
        case 166:
        case 167:
        case 168:
        case 169:
        case 170:
        case 171:
        case 172:
        case 173:
        case 174:
        case 175:
        case 176:
        case 177:
        case 178:
        case 179:
        case 180:
        case 181:
        case 182:
        case 183:
        case 184:
        case 185:
        case 186:
        case 187:
        case 188:
        case 189:
        case 190:
        case 191:
        case 192:
        case 193:
        case 194:
        case 195:
        case 196:
        case 197:
        case 198:
        case 199:
            return [NSString stringWithFormat:@"%@ %@", @"сто", [NSString ordinalRepresentationWithNumber:ordinal - 100]];
            break;

        default:
            return [NSString stringWithFormat:@"%ld-й", (long)ordinal];
            break;
    }
}


@end
