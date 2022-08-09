-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_pont_aval_nutri_md ( IE_RESPIRACAO_P text, QT_IMC_P bigint, qt_idade_P bigint, qt_peso_atual_P bigint, IE_QUEIMADURA_P text, IE_TRAUMA_P text, ie_sexo_P text, QT_GAST_ENER_TOTAL_IRETON_P INOUT bigint, QT_GAST_ENER_TOTAL_IRETON_KJ_P INOUT bigint ) AS $body$
DECLARE


qt_obesidade_w bigint;
qt_pont_queimadura_w bigint;
qt_pont_trauma_w bigint;
qt_pont_sexo_w bigint;


BEGIN
if (IE_RESPIRACAO_P IS NOT NULL AND IE_RESPIRACAO_P::text <> '') then
	if (IE_RESPIRACAO_P = 'ESP') then

		if (QT_IMC_P IS NOT NULL AND QT_IMC_P::text <> '') then
			if (QT_IMC_P > 27) then
				qt_obesidade_w	:= 1;
			else
				qt_obesidade_w	:= 0;
			end if;
		end if;

		QT_GAST_ENER_TOTAL_IRETON_P := 629 - coalesce((11 * qt_idade_P),0) + coalesce((25 * qt_peso_atual_P),0) - coalesce((609 * qt_obesidade_w),0);
        QT_GAST_ENER_TOTAL_IRETON_KJ_P := converter_kcal_kjoules_md(QT_GAST_ENER_TOTAL_IRETON_P,'KJ');
	end if;

	if (IE_RESPIRACAO_P = 'MEC') then

		if (IE_QUEIMADURA_P = 'S') then
			qt_pont_queimadura_w := 1;
		else
			qt_pont_queimadura_w := 0;
		end if;

		if (IE_TRAUMA_P = 'S') then
			qt_pont_trauma_w := 1;
		else
			qt_pont_trauma_w := 0;
		end if;

		if (ie_sexo_P = 'M') then
			qt_pont_sexo_w := 1;
		else
			qt_pont_sexo_w := 0;
		end if;

		QT_GAST_ENER_TOTAL_IRETON_P := 1784 - coalesce((11 * qt_idade_P),0) + coalesce((5 * qt_peso_atual_P),0) + coalesce((244 * qt_pont_sexo_w),0) + coalesce((239 * qt_pont_trauma_w),0) + coalesce((840 * qt_pont_queimadura_w),0);
        QT_GAST_ENER_TOTAL_IRETON_KJ_P := converter_kcal_kjoules_md(QT_GAST_ENER_TOTAL_IRETON_P,'KJ');
	end if;
end if;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_pont_aval_nutri_md ( IE_RESPIRACAO_P text, QT_IMC_P bigint, qt_idade_P bigint, qt_peso_atual_P bigint, IE_QUEIMADURA_P text, IE_TRAUMA_P text, ie_sexo_P text, QT_GAST_ENER_TOTAL_IRETON_P INOUT bigint, QT_GAST_ENER_TOTAL_IRETON_KJ_P INOUT bigint ) FROM PUBLIC;
