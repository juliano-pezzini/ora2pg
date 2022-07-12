-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS escala_framingham_fa_atual ON escala_framingham_fa CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_escala_framingham_fa_atual() RETURNS trigger AS $BODY$
BEGIN

NEW.QT_SCORE := 0;

if (NEW.qt_idade = 56) Then
	NEW.QT_SCORE := 1;
Elsif (NEW.qt_idade = 57) Then
	NEW.QT_SCORE := 2;
Elsif	((NEW.qt_idade = 58)
Or (NEW.qt_idade = 59)) Then
	NEW.QT_SCORE := 3;
Elsif (NEW.qt_idade = 60) Then
	NEW.QT_SCORE := 4;
Elsif (NEW.qt_idade = 61) Then
	NEW.QT_SCORE := 5;
Elsif (NEW.qt_idade = 62) Then
	NEW.QT_SCORE := 6;
Elsif (NEW.qt_idade = 63) Then
	NEW.QT_SCORE := 7;
Elsif	((NEW.qt_idade = 64)
Or (NEW.qt_idade = 65)) Then
	NEW.QT_SCORE := 8;
Elsif (NEW.qt_idade = 66) Then
	NEW.QT_SCORE := 9;
Elsif (NEW.qt_idade <= 67) Then
	NEW.QT_SCORE := 10;
Elsif (NEW.qt_idade <= 68) Then
	NEW.QT_SCORE := 11;
Elsif (NEW.qt_idade <= 69) Then
	NEW.QT_SCORE := 12;
Elsif	((NEW.qt_idade = 70)
Or (NEW.qt_idade = 71)) Then
	NEW.QT_SCORE := 13;
Elsif (NEW.qt_idade = 72) Then
	NEW.QT_SCORE := 14;
Elsif (NEW.qt_idade <= 73) Then
	NEW.QT_SCORE := 15;
Elsif (NEW.qt_idade <= 74) Then
	NEW.QT_SCORE := 16;
Elsif (NEW.qt_idade <= 75) Then
	NEW.QT_SCORE := 17;
Elsif	((NEW.qt_idade = 76)
Or (NEW.qt_idade = 77)) Then
	NEW.QT_SCORE := 18;
Elsif (NEW.qt_idade = 78) Then
	NEW.QT_SCORE := 19;
Elsif (NEW.qt_idade = 79) Then
	NEW.QT_SCORE := 20;
Elsif (NEW.qt_idade = 80) Then
	NEW.QT_SCORE := 21;
Elsif (NEW.qt_idade = 81) Then
	NEW.QT_SCORE := 22;
Elsif	((NEW.qt_idade = 82)
Or (NEW.qt_idade = 83)) Then
	NEW.QT_SCORE := 23;
Elsif (NEW.qt_idade = 84) Then
	NEW.QT_SCORE := 24;
Elsif (NEW.qt_idade = 85) Then
	NEW.QT_SCORE := 25;
Elsif (NEW.qt_idade = 86) Then
	NEW.QT_SCORE := 26;
Elsif (NEW.qt_idade = 87) Then
	NEW.QT_SCORE := 27;
Elsif (NEW.qt_idade = 88) Then
	NEW.QT_SCORE := 28;
Elsif (NEW.qt_idade = 89) Then
	NEW.QT_SCORE := 29;
Elsif	((NEW.qt_idade = 90)
Or (NEW.qt_idade = 91)) Then
	NEW.QT_SCORE := 30;
Elsif (NEW.qt_idade = 92) Then
	NEW.QT_SCORE := 31;
Elsif (NEW.qt_idade = 93) Then
	NEW.QT_SCORE := 32;
Elsif (NEW.qt_idade = 94) Then
	NEW.QT_SCORE := 33;
End if;

If	(NEW.QT_PA_SISTOLICA > 120 AND NEW.QT_PA_SISTOLICA < 139) Then
	NEW.QT_SCORE := NEW.QT_SCORE + 1;
Elsif	(NEW.QT_PA_SISTOLICA > 140 AND NEW.QT_PA_SISTOLICA < 159) Then
	NEW.QT_SCORE := NEW.QT_SCORE + 2;
Elsif	(NEW.QT_PA_SISTOLICA > 160 AND NEW.QT_PA_SISTOLICA < 179) Then
	NEW.QT_SCORE := NEW.QT_SCORE + 3;
Elsif (NEW.QT_PA_SISTOLICA > 179) Then
	NEW.QT_SCORE := NEW.QT_SCORE + 5;
End if;

If (NEW.IE_DIABETES = 'S') Then
	NEW.QT_SCORE := NEW.QT_SCORE + 4;
End if;

If (NEW.IE_TABAGISMO = 'S') Then
	NEW.QT_SCORE := NEW.QT_SCORE + 5;
End if;

If (NEW.IE_IAM_ICC = 'S') Then
	NEW.QT_SCORE := NEW.QT_SCORE + 6;
End if;

If (NEW.IE_SOPRO_MITRAL = 'S') Then
	NEW.QT_SCORE := NEW.QT_SCORE + 4;
End if;

If (NEW.IE_HVE_ECG = 'S') Then
	NEW.QT_SCORE := NEW.QT_SCORE + 2;
End if;


RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_escala_framingham_fa_atual() FROM PUBLIC;

CREATE TRIGGER escala_framingham_fa_atual
	BEFORE INSERT OR UPDATE ON escala_framingham_fa FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_escala_framingham_fa_atual();

