-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_alterar_vigencia_sca ( nr_seq_vinculo_sca_p bigint, dt_alteracao_p timestamp, ie_commit_p text, nm_usuario_p text) AS $body$
DECLARE


nr_seq_segurado_w	bigint;
dt_inicio_vigencia_w	timestamp;

C01 CURSOR FOR
	SELECT	a.nr_sequencia,
		trunc(coalesce(a.dt_inicio_cobertura,c.dt_mesano_referencia),'mm') dt_referencia,
		a.nr_parcela
	from	pls_mensalidade_sca a,
		pls_mensalidade_seg_item b,
		pls_mensalidade_segurado c	
	where	a.nr_seq_vinculo_sca = nr_seq_vinculo_sca_p
	and	b.nr_sequencia = a.nr_seq_item_mens
	and     c.nr_sequencia = b.nr_seq_mensalidade_seg;	
	
BEGIN

select	nr_seq_segurado,
	dt_inicio_vigencia
into STRICT	nr_seq_segurado_w,
	dt_inicio_vigencia_w
from	pls_sca_vinculo
where	nr_sequencia	= nr_seq_vinculo_sca_p;

update	pls_sca_vinculo
set	dt_inicio_vigencia	= dt_alteracao_p,
	nm_usuario		= nm_usuario_p,
	dt_atualizacao		= clock_timestamp()
where	nr_sequencia		= nr_seq_vinculo_sca_p;

CALL pls_gerar_segurado_historico(
		nr_seq_segurado_w, '49', clock_timestamp(),
		'De: ' || dt_inicio_vigencia_w || '. Para: ' || dt_alteracao_p, 'pls_alterar_inicio_vigencia_sca', null,
		null, null, null,
		null, null, null,
		null, null, null,
		null, nm_usuario_p, 'N');

for c01_w in C01 loop
	begin
	if (c01_w.dt_referencia < trunc(dt_alteracao_p,'mm')) and (c01_w.nr_parcela > 0) then
		update  pls_mensalidade_sca
		set	nr_parcela 	= nr_parcela * -1,
			nm_usuario 	= nm_usuario_p,
			dt_atualizacao  = clock_timestamp()
		where	nr_sequencia 	= c01_w.nr_sequencia;
	elsif (c01_w.dt_referencia >= trunc(dt_alteracao_p,'mm')) then
		update  pls_mensalidade_sca
		set	nr_parcela 	= trunc(months_between(c01_w.dt_referencia,trunc(dt_alteracao_p,'month'))) + 1,
			nm_usuario 	= nm_usuario_p,
			dt_atualizacao  = clock_timestamp()
		where	nr_sequencia 	= c01_w.nr_sequencia;
	end if;		
	end;
end loop;

if (ie_commit_p = 'S') then
	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_alterar_vigencia_sca ( nr_seq_vinculo_sca_p bigint, dt_alteracao_p timestamp, ie_commit_p text, nm_usuario_p text) FROM PUBLIC;
