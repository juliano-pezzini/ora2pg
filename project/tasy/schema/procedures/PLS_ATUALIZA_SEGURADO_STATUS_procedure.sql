-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_atualiza_segurado_status (( nr_seq_segurado_p pls_segurado.nr_sequencia%type, ie_tipo_p bigint, dt_referencia_p pls_segurado_status.dt_inicial%type, nr_seq_motivo_cancel_p pls_segurado_status.nr_seq_motivo_cancelamento%type, nr_seq_plano_p pls_plano.nr_sequencia%type, nr_seq_alt_plano_p pls_segurado_alt_plano.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, ie_commit_p text default 'S') is /*
ie_tipo_p
	1-Inclusao;
	2-Exclusao;
	3-Reativacao;
	4-Alteracao de produto
*/
 dt_final_ref_w pls_segurado_status.dt_final_ref%type) RETURNS varchar AS $body$
DECLARE

ie_plano_diferente_w	varchar(1);
BEGIN
select	CASE WHEN count(1)=0 THEN 'N'  ELSE 'S' END
into STRICT	ie_plano_diferente_w
from	pls_plano a
where	a.nr_sequencia	= nr_seq_plano_atual_p
and	exists (	SELECT	1
		from	pls_plano b
		where	b.nr_sequencia	= nr_seq_plano_ant_p
		and (a.nr_protocolo_ans <> b.nr_protocolo_ans or
			 a.cd_scpa <> b.cd_scpa or
			 a.ie_regulamentacao <> b.ie_regulamentacao)
		);

return	ie_plano_diferente_w;
end;

function obter_se_grupo_contratual(	nr_seq_contrato_atual_p		pls_contrato.nr_sequencia%type,
				nr_seq_contrato_ant_p		pls_contrato.nr_sequencia%type)
			return varchar2 is
ie_grupo_contratual_w	varchar2(1);
begin

select	CASE WHEN count(1)=0 THEN 'N'  ELSE 'S' END
into STRICT	ie_grupo_contratual_w
from	pls_contrato_grupo a
where	a.nr_seq_contrato	= nr_seq_contrato_atual_p
and	exists (	SELECT	1
		from	pls_contrato_grupo x
		where	x.nr_seq_contrato	= nr_seq_contrato_ant_p
		and	x.nr_seq_grupo		= a.nr_seq_grupo);

return	ie_grupo_contratual_w;
end;

begin

select	max(ie_exclusao_inclusao_dia_sib)
into STRICT	ie_exclusao_inclusao_dia_sib_w
from	pls_parametros
where	cd_estabelecimento	= cd_estabelecimento_p;

if (dt_referencia_p IS NOT NULL AND dt_referencia_p::text <> '') and (nr_seq_segurado_p IS NOT NULL AND nr_seq_segurado_p::text <> '') then
	if (ie_tipo_p = 1) then
		select	a.nr_seq_segurado_ant,
			a.dt_contratacao,
			a.nr_seq_contrato
		into STRICT	nr_seq_segurado_ant_w,
			dt_contratacao_w,
			nr_seq_contrato_atual_w
		from	pls_segurado a
		where	a.nr_sequencia	= nr_seq_segurado_p;
		
		ie_envio_sib_w	:= 1; --Inclusao
		if (nr_seq_segurado_ant_w IS NOT NULL AND nr_seq_segurado_ant_w::text <> '') then --Migracao
			select	max(a.nr_sequencia),
				max(b.dt_rescisao),
				max(b.cd_cco),
				max(b.nr_seq_plano),
				max(b.nr_seq_contrato)
			into STRICT	nr_seq_status_exclusao_w,
				dt_rescisao_w,
				cd_cco_w,
				nr_seq_plano_ant_w,
				nr_seq_contrato_ant_w
			from	pls_segurado_status a,
				pls_segurado b
			where	b.nr_sequencia	= a.nr_seq_segurado
			and	b.nr_sequencia	= nr_seq_segurado_ant_w
			and	(a.dt_final IS NOT NULL AND a.dt_final::text <> '')
			and	a.ie_exclusao_sib = 4;
			
			if (dt_rescisao_w IS NOT NULL AND dt_rescisao_w::text <> '') and --Verificar se o beneficiario anterior foi rescindido
				(cd_cco_w IS NOT NULL AND cd_cco_w::text <> '') then --O beneficiario anterior precisa ter CCO informado para fazer mudanca contratual/retificacao
				--Verificar se ja foi enviada exclusao para o beneficiario anterior, se sim, o novo beneficiario sera enviado como inclusao e recebera um novo CCO
				select	count(1)
				into STRICT	qt_registro_w
				from	pls_sib_movimento
				where	nr_seq_status_exclusao = nr_seq_status_exclusao_w;
				
				if (qt_registro_w = 0) then
					qt_dias_intervalo_migracao_w	:= trunc(dt_contratacao_w,'dd') - trunc(dt_rescisao_w,'dd'); --Intervalo de dias entre a contratacao do novo produto e a rescisao do anterior
					ie_codigo_plano_diferente_w	:= obter_se_plano_diferente(nr_seq_plano_p,nr_seq_plano_ant_w);
					ie_mesmo_grupo_contratual_w	:= obter_se_grupo_contratual(nr_seq_contrato_ant_w,nr_seq_contrato_atual_w);
					
					for r_c01_w in C01(qt_dias_intervalo_migracao_w, ie_codigo_plano_diferente_w, ie_mesmo_grupo_contratual_w) loop
						begin
						ie_envio_sib_w	:= r_c01_w.ie_movimento_sib;
						end;
					end loop; --C01
					
					if (ie_envio_sib_w in (2,3)) then --Se for retificacao ou mudanca contratual, deve atualizar o tipo de exclusao do beneficiario anterior para nao enviar como exclusao, e tambem copiar o CCO para o novo beneficiario
						update	pls_segurado_status
						set	ie_exclusao_sib	= ie_envio_sib_w
						where	nr_sequencia	= nr_seq_status_exclusao_w;
						
						update	pls_segurado
						set	cd_cco		= cd_cco_w
						where	nr_sequencia	= nr_seq_segurado_p;
					end if;
				end if;
			end if;
		end if;
		
		select	count(1)
		into STRICT	qt_registro_w
		from	pls_sib_lote
		where	cd_estabelecimento	= cd_estabelecimento_p
		and	ie_tipo_lote		= 'M';
		
		if (ie_envio_sib_w = 1) and --Se for inclusao, deve limpar o CCO, pois na rotina PLS_MIGRAR_SEGURADO_CONTRATO o CCO do beneficiario anterior e copiado para o novo beneficiario
			(qt_registro_w > 0) then --Deve limpar o CCO somente se o cliente estiver utilizando a nova funcao do SIB
			update	pls_segurado
			set	cd_cco		 = NULL
			where	nr_sequencia	= nr_seq_segurado_p;
		end if;
		
		dt_final_ref_w	:= pls_util_pck.obter_dt_vigencia_null(null,'F');
		
		select	count(1)
		into STRICT	qt_sib_status_inclusao_w
		from	pls_segurado_status
		where	nr_seq_segurado	= nr_seq_segurado_p
		and	nr_seq_plano	= nr_seq_plano_p
		and	ie_envio_sib	= ie_envio_sib_w
		and	trunc(dt_inicial,'dd') = trunc(dt_referencia_p,'dd');
		
		if (qt_sib_status_inclusao_w = 0) then
			insert into pls_segurado_status(nr_sequencia, nr_seq_segurado, dt_inicial,
				dt_final_ref, dt_atualizacao, nm_usuario,
				dt_atualizacao_nrec, nm_usuario_nrec, ie_envio_sib,
				nr_seq_plano)
			values (	nextval('pls_segurado_status_seq'), nr_seq_segurado_p, dt_referencia_p,
				dt_final_ref_w,	clock_timestamp(), nm_usuario_p,
				clock_timestamp(), nm_usuario_p, ie_envio_sib_w,
				nr_seq_plano_p);
		end if;
	elsif (ie_tipo_p = 2) then
		update	pls_segurado_status
		set	dt_final	= fim_dia(dt_referencia_p),
			dt_final_ref	= dt_referencia_p,
			nr_seq_motivo_cancelamento = nr_seq_motivo_cancel_p,
			dt_atualizacao	= clock_timestamp(),
			nm_usuario	= nm_usuario_p,
			ie_exclusao_sib	= 4
		where	nr_seq_segurado = nr_seq_segurado_p
		and	coalesce(dt_final::text, '') = '';
	elsif (ie_tipo_p = 3) then
		dt_final_ref_w	:= pls_util_pck.obter_dt_vigencia_null(null,'F');
		
		select	max(a.nr_sequencia)
		into STRICT	nr_seq_status_exclusao_w
		from	pls_segurado_status a
		where	a.nr_seq_segurado	= nr_seq_segurado_p
		and	a.dt_final >= fim_dia(dt_referencia_p)
		and	not exists (	SELECT	1 --So pode alterar o status atual se ainda nao foi enviado no SIB
					from	pls_sib_movimento x
					where	x.nr_seq_status_exclusao = a.nr_sequencia);
		
		if (ie_exclusao_inclusao_dia_sib_w = 'N') and (nr_seq_status_exclusao_w IS NOT NULL AND nr_seq_status_exclusao_w::text <> '') then
			update	pls_segurado_status
			set	dt_final	 = NULL,
				dt_final_ref	= dt_final_ref_w,
				ie_exclusao_sib	 = NULL,
				nr_seq_motivo_cancelamento  = NULL,
				dt_atualizacao	= clock_timestamp(),
				nm_usuario	= nm_usuario_p
			where	nr_sequencia	= nr_seq_status_exclusao_w;
		else
			insert into pls_segurado_status(nr_sequencia, nr_seq_segurado, dt_inicial,
				dt_final_ref, dt_atualizacao, nm_usuario,
				dt_atualizacao_nrec, nm_usuario_nrec, ie_envio_sib,
				nr_seq_plano)
			values (	nextval('pls_segurado_status_seq'), nr_seq_segurado_p, dt_referencia_p,
				dt_final_ref_w,	clock_timestamp(), nm_usuario_p,
				clock_timestamp(), nm_usuario_p, 5,
				nr_seq_plano_p);
		end if;
	elsif (ie_tipo_p = 4) then
		ie_envio_sib_w	:= null;
		dt_final_ref_w	:= pls_util_pck.obter_dt_vigencia_null(null,'F');
		
		select	a.nr_seq_plano_atual,
			a.nr_seq_plano_ant,
			coalesce(b.ie_acao_alt_produto,'M')
		into STRICT	nr_seq_plano_atual_w,
			nr_seq_plano_ant_w,
			ie_acao_alt_produto_w
		from	pls_segurado_alt_plano a,
			pls_motivo_alteracao_plano b
		where	b.nr_sequencia	= a.nr_seq_motivo_alt
		and	a.nr_sequencia	= nr_seq_alt_plano_p;
		
		if (ie_acao_alt_produto_w = 'M') and (nr_seq_plano_atual_w <> nr_seq_plano_ant_w) then
			if (obter_se_plano_diferente(nr_seq_plano_atual_w,nr_seq_plano_ant_w) = 'S') then
				ie_envio_sib_w	:= 3; --Mudanca contratual
			end if;
		end if;
		
		select	max(nr_sequencia)
		into STRICT	nr_seq_segurado_status_w
		from	pls_segurado_status
		where	nr_seq_segurado	= nr_seq_segurado_p
		and	coalesce(dt_final::text, '') = '';
		
		update	pls_segurado_status
		set	ie_exclusao_sib	= ie_envio_sib_w,
			dt_final	= fim_dia(dt_referencia_p-1),
			dt_final_ref	= fim_dia(dt_referencia_p-1)
		where	nr_sequencia	= nr_seq_segurado_status_w;
		
		insert into pls_segurado_status(nr_sequencia, nr_seq_segurado, dt_inicial,
			dt_final_ref, dt_atualizacao, nm_usuario,
			dt_atualizacao_nrec, nm_usuario_nrec, ie_envio_sib,
			nr_seq_plano)
		values (	nextval('pls_segurado_status_seq'), nr_seq_segurado_p, dt_referencia_p,
			dt_final_ref_w,	clock_timestamp(), nm_usuario_p,
			clock_timestamp(), nm_usuario_p, ie_envio_sib_w,
			nr_seq_plano_atual_w);
	end if;
end if;

if (ie_commit_p = 'S') then
	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_atualiza_segurado_status (( nr_seq_segurado_p pls_segurado.nr_sequencia%type, ie_tipo_p bigint, dt_referencia_p pls_segurado_status.dt_inicial%type, nr_seq_motivo_cancel_p pls_segurado_status.nr_seq_motivo_cancelamento%type, nr_seq_plano_p pls_plano.nr_sequencia%type, nr_seq_alt_plano_p pls_segurado_alt_plano.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, ie_commit_p text default 'S') is  dt_final_ref_w pls_segurado_status.dt_final_ref%type) FROM PUBLIC;
