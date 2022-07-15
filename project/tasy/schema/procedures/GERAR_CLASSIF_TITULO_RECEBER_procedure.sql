-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_classif_titulo_receber ( nr_interno_conta_p bigint, nr_seq_protocolo_p bigint, nm_usuario_p text, nr_seq_lote_protocolo_p bigint) AS $body$
DECLARE


nr_titulo_w			bigint	:= 0;
vl_titulo_w			double precision	:= 0;
vl_tot_titulo_w			double precision	:= 0;
nr_seq_conta_financ_w		bigint	:= 0;
vl_tot_classif_w			double precision	:= 0;
vl_classif_w			double precision	:= 0;
vl_conta_w			double precision	:= 0;
vl_tot_conta_w			double precision	:= 0;
nr_seq_conta_cre_w		bigint	:= 0;
nr_sequencia_w			bigint	:= 0;
cd_estabelecimento_w		integer;
cd_centro_custo_w			bigint;
cd_setor_atendimento_w		bigint;
cont_w				bigint;
cd_convenio_w			bigint;
nr_interno_conta_w			bigint;
nr_seq_produto_w			bigint;
cd_conta_contabil_w		varchar(100);
ie_vinc_tit_prot_w			varchar(1);
nr_seq_conta_financ_ww		bigint;
nr_seq_trans_fin_w		bigint;
cd_cgc_w			varchar(14);
cd_pessoa_fisica_w		varchar(255);
nr_seq_proj_rec_w		bigint;
ie_origem_titulo_w		varchar(10);
nr_seq_classe_tit_rec_w		bigint;
cd_convenio_conta_w		integer;
ie_tipo_titulo_rec_w		titulo_receber.ie_tipo_titulo%type;
cd_moeda_w			titulo_receber.cd_moeda%type;

c01 CURSOR FOR
SELECT 	nr_titulo,
	vl_titulo,
	cd_estabelecimento,
	nr_interno_conta
from 	titulo_receber
where 	nr_interno_conta	= nr_interno_conta_p
and 	(nr_interno_conta_p IS NOT NULL AND nr_interno_conta_p::text <> '')
and 	coalesce(nr_seq_protocolo_p::text, '') = ''

union

SELECT 	nr_titulo,
	vl_titulo,
	cd_estabelecimento,
	nr_interno_conta
from 	titulo_receber
where 	nr_seq_protocolo	= nr_seq_protocolo_p
and 	coalesce(nr_interno_conta_p::text, '') = ''
and 	(nr_seq_protocolo_p IS NOT NULL AND nr_seq_protocolo_p::text <> '')

union

select	a.nr_titulo,
	a.vl_titulo,
	a.cd_estabelecimento,
	a.nr_interno_conta
from	titulo_receber a
where	a.nr_interno_conta	in (select	x.nr_interno_conta
	from	conta_paciente x
	where	x.nr_seq_protocolo	= nr_seq_protocolo_p)
and	coalesce(nr_interno_conta_p::text, '') = ''
and	(nr_seq_protocolo_p IS NOT NULL AND nr_seq_protocolo_p::text <> '')
and	ie_vinc_tit_prot_w	= 'N'

union

select	a.nr_titulo,
	a.vl_titulo,
	a.cd_estabelecimento,
	a.nr_interno_conta
from	titulo_receber a
where	a.nr_seq_lote_prot	= nr_seq_lote_protocolo_p
and	coalesce(nr_interno_conta_p::text, '') = ''
and	(nr_seq_lote_protocolo_p IS NOT NULL AND nr_seq_lote_protocolo_p::text <> '');

c02 CURSOR FOR
SELECT 	CASE WHEN coalesce(nr_seq_conta_financ::text, '') = '' THEN  nr_seq_conta_cre_w WHEN nr_seq_conta_financ=0 THEN  nr_seq_conta_cre_w  ELSE nr_seq_conta_financ END ,
	sum(coalesce(vl_procedimento,0) + coalesce(vl_material,0)),
	cd_setor_atendimento,
	cd_conta_contabil,
	nr_seq_produto
from 	conta_paciente_resumo
where 	1 = 1 --(nvl(vl_procedimento,0) + nvl(vl_material,0)) <> 0 -- OS 2188455, com essa restricao os valores negativos de procs e mats na conta nao sao considerados no calculo, gerando diff na classif do titulo X resumo da conta
and	nr_interno_conta in (
		SELECT	nr_interno_conta
		from	conta_paciente
	  	where	nr_interno_conta	= nr_interno_conta_p
		and	(nr_interno_conta_p IS NOT NULL AND nr_interno_conta_p::text <> '')
		and	coalesce(nr_seq_protocolo_p::text, '') = ''
		
union

		select	nr_interno_conta
		from	conta_paciente
	  	where	nr_seq_protocolo	= nr_seq_protocolo_p
		and	nr_interno_conta	= coalesce(nr_interno_conta_w, nr_interno_conta)
		and	coalesce(nr_interno_conta_p::text, '') = ''
		and	(nr_seq_protocolo_p IS NOT NULL AND nr_seq_protocolo_p::text <> '')
		
union

		select	nr_interno_conta
		from	titulo_receber
		where	nr_interno_conta	in (select	nr_interno_conta
			from	conta_paciente
			where	nr_seq_protocolo	= nr_seq_protocolo_p)
		and	coalesce(nr_interno_conta_p::text, '') = ''
		and	(nr_seq_protocolo_p IS NOT NULL AND nr_seq_protocolo_p::text <> '')
		and	ie_vinc_tit_prot_w	= 'N'
		
union

		select	a.nr_interno_conta
		from	conta_paciente a,
			protocolo_convenio b
		where	a.nr_seq_protocolo	= b.nr_seq_protocolo
		and	b.nr_seq_lote_protocolo	= nr_seq_lote_protocolo_p
		and	(nr_seq_lote_protocolo_p IS NOT NULL AND nr_seq_lote_protocolo_p::text <> ''))
group 	by nr_seq_conta_financ,
	cd_setor_atendimento,
	cd_conta_contabil,
	nr_seq_produto
having sum(coalesce(vl_procedimento,0) + coalesce(vl_material,0)) > 0;


BEGIN

ie_vinc_tit_prot_w		:= obter_valor_param_usuario(-80,57, obter_perfil_ativo, nm_usuario_p, 0);

if (coalesce(nr_interno_conta_p,0) > 0) then
	select	max(cd_estabelecimento)
	into STRICT	cd_estabelecimento_w
	from	conta_paciente
	where	nr_interno_conta	= nr_interno_conta_p;
else
	select	max(cd_estabelecimento)
	into STRICT	cd_estabelecimento_w
	from	protocolo_convenio
	where	nr_seq_protocolo	= nr_seq_protocolo_p;
end if;

select	coalesce(max(cd_conta_financ_cre),1)
into STRICT	nr_seq_conta_cre_w
from	parametro_fluxo_caixa
where	cd_estabelecimento	= cd_estabelecimento_w;

open  c01;
loop
fetch c01 into
	nr_titulo_w,
	vl_titulo_w,
	cd_estabelecimento_w,
	nr_interno_conta_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	vl_tot_titulo_w	:= 	vl_tot_titulo_w + vl_titulo_w;
end loop;
close c01;

open  c01;
loop
fetch c01 into
	nr_titulo_w,
	vl_titulo_w,
	cd_estabelecimento_w,
	nr_interno_conta_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

	open  c02;
	loop
	fetch c02 into
		nr_seq_conta_financ_w,
		vl_conta_w,
		cd_setor_atendimento_w,
		cd_conta_contabil_w,
		nr_seq_produto_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */
		vl_tot_conta_w	:= 	vl_tot_conta_w	+ vl_conta_w;
	end loop;
	close c02;

	vl_tot_classif_w	:= 0;

	open  c02;
	loop
	fetch c02 into
       		nr_seq_conta_financ_w,
		vl_conta_w,
		cd_setor_atendimento_w,
		cd_conta_contabil_w,
		nr_seq_produto_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */
		begin
			
		select	count(*)			/* edgar 14/08/2003 - verificar se a conta financeira ainda existe os 2097*/
		into STRICT	cont_w
		from	conta_financeira
		where	cd_conta_financ = nr_seq_conta_financ_w;
		if (cont_w = 0) then
			begin
			select	cd_conta_financ_cre
			into STRICT	nr_seq_conta_financ_w
			from	parametro_fluxo_caixa
			where	cd_estabelecimento = cd_estabelecimento_w;
			exception
				when no_data_found then
					begin
					/*r.aise_application_error(-20011, 'Os parametros do fluxo de caixa nao estao cadastrados!');*/

					CALL wheb_mensagem_pck.exibir_mensagem_abort(208161);
					end;
			end;
		end if;

		select	max(cd_centro_custo)
		into STRICT	cd_centro_custo_w
		from	setor_atendimento
		where	cd_setor_atendimento	= cd_setor_atendimento_w;

		vl_classif_w	:= (vl_titulo_w  * dividir_sem_round(vl_conta_w, vl_tot_conta_w));
		vl_tot_classif_w	:= vl_tot_classif_w + vl_classif_w;
		
		if (cd_conta_contabil_w = '0') then
			cd_conta_contabil_w := null;
		end if;
		
		select	a.cd_estabelecimento,
			a.cd_cgc,
			a.nr_seq_proj_rec,
			a.vl_titulo,
			a.cd_pessoa_fisica,
			a.ie_origem_titulo,
			a.nr_seq_classe,
			a.nr_seq_trans_fin_contab,
			a.cd_convenio_conta,
			a.ie_tipo_titulo,
			a.cd_moeda
		into STRICT	cd_estabelecimento_w,
			cd_cgc_w,
			nr_seq_proj_rec_w,
			vl_titulo_w,
			cd_pessoa_fisica_w,
			ie_origem_titulo_w,
			nr_seq_classe_tit_rec_w,
			nr_seq_trans_fin_w,
			cd_convenio_conta_w,
			ie_tipo_titulo_rec_w,
			cd_moeda_w
		from	titulo_receber a
		where	a.nr_titulo		= nr_titulo_w;

		if (nr_seq_trans_fin_w IS NOT NULL AND nr_seq_trans_fin_w::text <> '') then
			nr_seq_conta_financ_ww := obter_conta_financeira(	'E', cd_estabelecimento_w, null, null, null, null, cd_convenio_conta_w, cd_cgc_w, null, nr_seq_conta_financ_ww, null, null, null, null, null, nr_seq_proj_rec_w, null, cd_pessoa_fisica_w, ie_origem_titulo_w, null, nr_seq_classe_tit_rec_w, null, null, nr_seq_trans_fin_w, null, null, null, ie_tipo_titulo_rec_w, cd_moeda_w);	

			if (nr_seq_conta_financ_ww = 0) then
				nr_seq_conta_financ_ww := null;
			end if;
		end if;
		
		select	coalesce(max(nr_sequencia),0) + 1
		into STRICT	nr_sequencia_w
		from	titulo_receber_classif
		where	nr_titulo = nr_titulo_w;
		
		insert into titulo_receber_classif(
			nr_titulo,
			nr_sequencia, 
			vl_classificacao,
			dt_atualizacao, 
			nm_usuario, 
			cd_conta_financ, 
			cd_centro_custo,
			cd_conta_contabil,
			nr_seq_produto)
		values (	nr_titulo_w, 
			nr_sequencia_w, 
			vl_classif_w,
			clock_timestamp(), 
			nm_usuario_p, 
			coalesce(nr_seq_conta_financ_ww, nr_seq_conta_financ_w), 
			cd_centro_custo_w,
			cd_conta_contabil_w,
			nr_seq_produto_w);
		end;

	end loop;
	close c02;

	if (vl_tot_classif_w <> vl_titulo_w) then
		update	titulo_receber_classif
		set	vl_classificacao 	= vl_classificacao + (vl_titulo_w -vl_tot_classif_w)
		where	nr_titulo		= nr_titulo_w
		and	nr_sequencia	= nr_sequencia_w;
	end if;

	end;
end loop;
close c01;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_classif_titulo_receber ( nr_interno_conta_p bigint, nr_seq_protocolo_p bigint, nm_usuario_p text, nr_seq_lote_protocolo_p bigint) FROM PUBLIC;

