-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_ocor_tit_rec_escrit (nr_titulo_p bigint) RETURNS varchar AS $body$
DECLARE


nr_seq_ocorrencia_ret_w			varchar(255);
ie_rejeitado_w				varchar(255);

c01 CURSOR FOR
SELECT	a.nr_seq_ocorrencia_ret
from	cobranca_escritural b,
	titulo_receber_cobr a
where	a.nr_seq_cobranca	= b.nr_sequencia
and	b.ie_remessa_retorno	= 'T'
and	a.nr_titulo		= nr_titulo_p
order 	by b.DT_REMESSA_RETORNO;



BEGIN

nr_seq_ocorrencia_ret_w			:= null;
open c01;
loop
fetch c01 into
	nr_seq_ocorrencia_ret_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
end loop;
close c01;

select	coalesce(max(ie_rejeitado),'N')
into STRICT	ie_rejeitado_w
from	BANCO_OCORR_ESCRIT_RET
where	nr_sequencia	= nr_seq_ocorrencia_ret_w;

if (ie_rejeitado_w = 'S') then
	return	nr_seq_ocorrencia_ret_w;
else
	return	null;
end if;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_ocor_tit_rec_escrit (nr_titulo_p bigint) FROM PUBLIC;
