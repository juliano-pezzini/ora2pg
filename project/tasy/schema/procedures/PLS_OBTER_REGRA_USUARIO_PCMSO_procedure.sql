-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_obter_regra_usuario_pcmso ( cd_usuario_plano_p text, nr_seq_congenere_p bigint, nr_seq_emissor_p INOUT bigint) AS $body$
DECLARE


NR_SEQ_EMISSOR_w		bigint;
nr_seq_congenere_w		bigint;
cd_cooperativa_w		varchar(10);


BEGIN

if (nr_seq_congenere_p IS NOT NULL AND nr_seq_congenere_p::text <> '') then
	nr_seq_congenere_w	:= nr_seq_congenere_p;
else
	cd_cooperativa_w	:= substr(cd_usuario_plano_p,2,3);

	begin
		select	max(nr_sequencia)
		into STRICT	nr_seq_congenere_w
		from	pls_congenere
		where	(coalesce(cd_cooperativa,0))::numeric  = (cd_cooperativa_w)::numeric;
	exception
	when others then
		nr_seq_congenere_w := 0;
	end;
end if;

select	max(nr_seq_emissor)
into STRICT	nr_seq_emissor_w
from	pls_congenere_cartao_pcmso
where	nr_seq_congenere	= nr_seq_congenere_w
and	((cd_usuario_plano	= cd_usuario_plano_p) or (coalesce(cd_usuario_plano::text, '') = ''))  LIMIT 1;

nr_seq_emissor_p	:= nr_seq_emissor_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_obter_regra_usuario_pcmso ( cd_usuario_plano_p text, nr_seq_congenere_p bigint, nr_seq_emissor_p INOUT bigint) FROM PUBLIC;
