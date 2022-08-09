-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_atualizar_status_cliente ( nr_seq_cliente_p bigint, nm_usuario_p text) AS $body$
DECLARE


/*	STATUS - dom 2664
	A               Aguardando prospecção
	E               Em prospecção
	R               Repasse de venda
	P               Prazo expirado
	C               Prospecção concluída
	N               Prospecção  cancelada
*/
ie_status_w			varchar(2);
dt_efetivacao_w			timestamp;
qt_dias_efetivacao_w		bigint;
qt_vendedor_ativo_w		bigint;
ie_status_novo_w		varchar(2);
qt_historico_lib_w		bigint;
qt_proposta_w			bigint;
nr_seq_motivo_cancelamento_w	bigint;
nr_seq_tipo_atividade_w		bigint;
cd_estabelecimento_w		smallint;
ds_status_w			varchar(255);
ds_status_novo_w		varchar(255);


BEGIN

select	coalesce(a.ie_status,'A'),
	a.dt_efetivacao,
	substr(pls_obter_dias_efetivacao(a.nr_sequencia,null),1,10),
	nr_seq_motivo_cancelamento,
	cd_estabelecimento
into STRICT	ie_status_w,
	dt_efetivacao_w,
	qt_dias_efetivacao_w,
	nr_seq_motivo_cancelamento_w,
	cd_estabelecimento_w
from	pls_comercial_cliente a
where	a.nr_sequencia	= nr_seq_cliente_p;

if (coalesce(nr_seq_motivo_cancelamento_w,0) <> 0) then
	ie_status_novo_w	:= 'N';
else
	select	count(*)
	into STRICT	qt_proposta_w
	from	pls_proposta_adesao
	where	nr_seq_cliente	= nr_seq_cliente_p;

	if (qt_proposta_w	> 0) then
		ie_status_novo_w	:= 'C';
	else
		if (coalesce(qt_dias_efetivacao_w,1) <= 0) then
			ie_status_novo_w	:= 'P';
		/*else
			select	count(*)
			into	qt_vendedor_ativo_w
			from	pls_solicitacao_vendedor a
			where	a.nr_seq_cliente	= nr_seq_cliente_p
			and	a.dt_fim_vigencia is null;

			if	(qt_vendedor_ativo_w > 0) then
				ie_status_novo_w	:= 'R';
			else
				select	count(*)
				into	qt_historico_lib_w
				from	pls_comercial_historico a,
					pls_tipo_atividade b
				where	a.ie_tipo_atividade	= b.nr_sequencia
				and	a.nr_seq_cliente	= nr_seq_cliente_p
				and	a.dt_liberacao is not null
				and	b.ie_fase_venda = 'N'
				and	b.ie_prorrogacao_efetivacao = 'N';

				if	(qt_historico_lib_w > 0) then
					ie_status_novo_w	:= 'E';
				else
					ie_status_novo_w	:= 'A';
				end if;
			end if;*/
		end if;
	end if;
end if;

if (ie_status_w <> ie_status_novo_w) then
	update	pls_comercial_cliente
	set	ie_status	= coalesce(ie_status_novo_w,ie_status_w)
	where	nr_sequencia	= nr_seq_cliente_p;

	select	max(nr_sequencia)
	into STRICT	nr_seq_tipo_atividade_w
	from	pls_tipo_atividade
	where	ie_status	= 'S';

	if (coalesce(nr_seq_tipo_atividade_w,0) > 0) then
		select	substr(obter_valor_dominio(2664,ie_status_w),1,200),
			substr(obter_valor_dominio(2664,ie_status_novo_w),1,200)
		into STRICT	ds_status_w,
			ds_status_novo_w
		;

		insert into pls_comercial_historico(	nr_sequencia,
							nr_seq_cliente,
							cd_estabelecimento,
							dt_atualizacao,
							nm_usuario,
							dt_atualizacao_nrec,
							nm_usuario_nrec,
							ds_titulo,
							ds_historico,
							dt_liberacao,
							nm_usuario_historico,
							ie_tipo_atividade,
							dt_historico)
						values (	nextval('pls_comercial_historico_seq'),
							nr_seq_cliente_p,
							cd_estabelecimento_w,
							clock_timestamp(),
							nm_usuario_p,
							clock_timestamp(),
							nm_usuario_p,
							'Alteração do status',
							'Alterado o status de "' || ds_status_w || '" para "' || ds_status_novo_w || '".',
							clock_timestamp(),
							nm_usuario_p,
							nr_seq_tipo_atividade_w,
							clock_timestamp());
	end if;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_atualizar_status_cliente ( nr_seq_cliente_p bigint, nm_usuario_p text) FROM PUBLIC;
