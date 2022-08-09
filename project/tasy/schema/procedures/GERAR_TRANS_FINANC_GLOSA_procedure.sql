-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_trans_financ_glosa (nr_seq_retorno_p bigint, nm_usuario_p text) AS $body$
DECLARE



nr_seq_trans_financ_w	bigint;
cd_estabelecimento_w	bigint;
nr_seq_partic_w		bigint;
nr_seq_ret_glosa_w	bigint;

c01 CURSOR FOR
SELECT	c.nr_sequencia,
	c.nr_seq_partic
from	convenio_retorno_glosa c,
	convenio_retorno_item b
where	b.nr_sequencia		= c.nr_seq_ret_item
and	b.nr_seq_retorno	= nr_seq_retorno_p;


BEGIN

begin
dbms_application_info.SET_ACTION('GERAR_TRANS_FINANC_GLOSA');

select	max(cd_estabelecimento)
into STRICT	cd_estabelecimento_w
from	convenio_retorno
where	nr_sequencia	= nr_seq_retorno_p;

open c01;
loop
fetch c01 into
	nr_seq_ret_glosa_w,
	nr_seq_partic_w;
EXIT WHEN NOT FOUND; /* apply on c01 */

	select	max(nr_seq_trans_financ)
	into STRICT	nr_seq_trans_financ_w
	from	regra_trans_fin_ret_glosa
	where	cd_estabelecimento	= cd_estabelecimento_w
	and	((ie_partic_glosa	= 'P' AND nr_seq_partic_w IS NOT NULL AND nr_seq_partic_w::text <> '') or
		 ((ie_partic_glosa	= 'S') and (coalesce(nr_seq_partic_w::text, '') = '')))
	and	cd_estabelecimento	= cd_estabelecimento_w;

	if (nr_seq_trans_financ_w IS NOT NULL AND nr_seq_trans_financ_w::text <> '') then
		update	convenio_retorno_glosa
		set	nr_seq_trans_financ	= nr_seq_trans_financ_w
		where	nr_sequencia		= nr_seq_ret_glosa_w;
	end if;

end loop;
close c01;

dbms_application_info.SET_ACTION('');

exception
	when others then
	dbms_application_info.SET_ACTION('');
	-- #@DS_ERRO#@
	CALL wheb_mensagem_pck.exibir_mensagem_abort(210215, 'DS_ERRO=' || sqlerrm);
end;


-- NÃO DAR COMMIT NESTA PROCEDURE
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_trans_financ_glosa (nr_seq_retorno_p bigint, nm_usuario_p text) FROM PUBLIC;
