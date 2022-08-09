-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE hd_atualizar_campos_dializador (nr_seq_maquina_p bigint, ie_operacao_p text, nr_seq_ponto_p INOUT bigint, nr_seq_osmose_p INOUT bigint) AS $body$
DECLARE


nr_seq_ponto_w		bigint;
nr_seq_osmose_w		bigint;


BEGIN

select	max(a.nr_seq_ponto) nr_seq_ponto
into STRICT	nr_seq_ponto_w
from 	hd_maquina_dialise a,
	hd_ponto_acesso b
where   	b.nr_sequencia = a.nr_seq_ponto
and	ie_local_ponto = 'N'
and	a.nr_sequencia = nr_seq_maquina_p;

nr_seq_osmose_w := obter_osmose_fixa(nr_seq_ponto_w);

nr_seq_ponto_p 	:= nr_seq_ponto_w;
nr_seq_osmose_p := nr_seq_osmose_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE hd_atualizar_campos_dializador (nr_seq_maquina_p bigint, ie_operacao_p text, nr_seq_ponto_p INOUT bigint, nr_seq_osmose_p INOUT bigint) FROM PUBLIC;
