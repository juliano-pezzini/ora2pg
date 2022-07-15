-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cancela_registro_obito ( nr_atendimento_p bigint, nr_declaracao_p text, ds_motivo_cancelado_p text, ie_motivo_cancelamento_p text, nm_usuario_p text ) AS $body$
DECLARE

 tipo_numeracao_w	regra_numeracao_declaracao.ie_tipo_numeracao%type;

BEGIN
	select *
	into STRICT tipo_numeracao_w
	from (
		SELECT  a.ie_tipo_numeracao
		from	regra_numeracao_declaracao a
		where	a.ie_situacao	= 'A'
		and	a.ie_tipo_numeracao	= 'DO'
		and	not exists (SELECT 1 from declaracao_obito x where x.nr_declaracao = ltrim(nr_declaracao_p, '0') and x.ie_situacao = 'A')
		and not exists (select 1
						from	nascimento x
						where	x.ie_unico_nasc_vivo = 'N'
						and	x.nr_atend_rn = nr_atendimento_p)
		
union all

		select  a.ie_tipo_numeracao
		from	regra_numeracao_declaracao a
		where		a.ie_situacao	= 'A'
		and	a.ie_tipo_numeracao	= 'DF'
		and	not exists (select 1 from declaracao_obito x where x.nr_declaracao = ltrim(nr_declaracao_p, '0') and x.ie_situacao = 'A')
		and exists (select 1
						from	nascimento x
						where	x.ie_unico_nasc_vivo = 'N'
						and	x.nr_atend_rn = nr_atendimento_p)) alias6;
	
if (nr_declaracao_p IS NOT NULL AND nr_declaracao_p::text <> '') then
	update	regra_numeracao_dec_item a
	set	a.dt_cancelamento = clock_timestamp(),
        a.ie_disponivel = 'C',
        a.ds_motivo_cancelado = ds_motivo_cancelado_p,
        a.ie_motivo_cancelamento = ie_motivo_cancelamento_p,
        a.dt_atualizacao = clock_timestamp(),
        a.nm_usuario = nm_usuario_p
	where a.nr_declaracao = nr_declaracao_p
    and exists (SELECT	1 from regra_numeracao_declaracao b 
    where a.NR_SEQ_REGRA_NUM = b.nr_sequencia 
    and b.ie_situacao = 'A' and b.ie_tipo_numeracao = tipo_numeracao_w);
	commit;
end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cancela_registro_obito ( nr_atendimento_p bigint, nr_declaracao_p text, ds_motivo_cancelado_p text, ie_motivo_cancelamento_p text, nm_usuario_p text ) FROM PUBLIC;

