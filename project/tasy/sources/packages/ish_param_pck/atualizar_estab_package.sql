-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE ish_param_pck.atualizar_estab ( nr_seq_fila_p bigint) AS $body$
DECLARE

		
nr_seq_projeto_xml_w		intpd_eventos_sistema.nr_seq_projeto_xml%type;

BEGIN
begin
select	b.nr_seq_projeto_xml
into STRICT	nr_seq_projeto_xml_w	
from	intpd_fila_transmissao a,
	intpd_eventos_sistema b
where	a.nr_seq_evento_sistema = b.nr_sequencia
and	a.nr_sequencia = nr_seq_fila_p;
exception
when others then
	nr_seq_projeto_xml_w	:=	null;
end;

if (substr(obter_se_integracao_ish(nr_seq_projeto_xml_w),1,1) = 'S') then
	CALL wheb_usuario_pck.set_cd_estabelecimento(get_cd_estab_ant);
end if;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ish_param_pck.atualizar_estab ( nr_seq_fila_p bigint) FROM PUBLIC;