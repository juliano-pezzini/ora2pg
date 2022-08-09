-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE verificar_se_trat_planej ( nr_seq_tratamento_p bigint, nr_seq_equipamento_p bigint, nm_usuario_p text, ie_trat_planej_p INOUT text, ds_mensagem_p INOUT text) AS $body$
BEGIN

ie_trat_planej_p	:= rxt_obter_se_trat_planej(nr_seq_tratamento_p, nr_seq_equipamento_p);

if ('S' = ie_trat_planej_p) then
	ds_mensagem_p	:= substr(obter_texto_tasy(85248, wheb_usuario_pck.get_nr_seq_idioma),1,255);
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE verificar_se_trat_planej ( nr_seq_tratamento_p bigint, nr_seq_equipamento_p bigint, nm_usuario_p text, ie_trat_planej_p INOUT text, ds_mensagem_p INOUT text) FROM PUBLIC;
