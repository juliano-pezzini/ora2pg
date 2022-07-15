-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_registros_previstos ( ie_tipo_calculo_p text, qt_perc_aumento_p bigint, qt_registros_p bigint, ie_previsto_menor_p text, ds_erro_p INOUT text) AS $body$
DECLARE




percentual_w		real;



BEGIN

percentual_w := (1 + qt_perc_aumento_p);

if (ie_tipo_calculo_p = 'R') then

	if (ie_previsto_menor_p = 'S') then

		UPDATE TABELA_SISTEMA
		SET qt_registros_previsto = qt_registros_atual * percentual_w
		WHERE IE_TIPO_CALCULO = 'R'
		AND qt_registros_previsto < qt_registros_atual;

	else

		UPDATE TABELA_SISTEMA
		SET qt_registros_previsto = qt_registros_atual * percentual_w
		WHERE IE_TIPO_CALCULO = 'R';

	end if;

elsif (ie_tipo_calculo_p = 'F') AND (qt_registros_p <> 0) then

	UPDATE TABELA_SISTEMA
	SET qt_registros_previsto = QT_FATOR_CONVERSAO * qt_registros_p
	WHERE IE_TIPO_CALCULO = ie_tipo_calculo_p;

else

	ds_erro_p := wheb_mensagem_pck.get_texto(285636); --'Informe a quantidade de registros';
end if;


commit;


END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_registros_previstos ( ie_tipo_calculo_p text, qt_perc_aumento_p bigint, qt_registros_p bigint, ie_previsto_menor_p text, ds_erro_p INOUT text) FROM PUBLIC;

