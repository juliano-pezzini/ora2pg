-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_consistir_classif_carencia ( nr_seq_classif_carencia_p bigint, qt_dias_p bigint, ds_erro_p INOUT text, nm_usuario_p text) AS $body$
DECLARE


qt_dias_w		bigint;
ds_erro_w		varchar(4000);


BEGIN

if (nr_seq_classif_carencia_p IS NOT NULL AND nr_seq_classif_carencia_p::text <> '') and (qt_dias_p IS NOT NULL AND qt_dias_p::text <> '') then
	select	max(qt_dias)
	into STRICT	qt_dias_w
	from	pls_classificacao_carencia
	where	nr_sequencia	= nr_seq_classif_carencia_p;

	if (qt_dias_w IS NOT NULL AND qt_dias_w::text <> '') then
		if (qt_dias_p > qt_dias_w) then
			ds_erro_w	:= wheb_mensagem_pck.get_texto(280871, 'QT_DIAS_P=' || qt_dias_w);
		end if;
	end if;
end if;

ds_erro_p	:= ds_erro_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_consistir_classif_carencia ( nr_seq_classif_carencia_p bigint, qt_dias_p bigint, ds_erro_p INOUT text, nm_usuario_p text) FROM PUBLIC;

