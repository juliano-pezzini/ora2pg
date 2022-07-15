-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE calcular_conpaci_desconto ( nr_sequencia_p bigint, ie_acao_p text, nm_usuario_p text) AS $body$
DECLARE


nr_interno_conta_w		bigint;

vl_desc_Proc_w			double precision := 0;
vl_desc_Mat_w			double precision := 0;

nr_sequencia_w			bigint;
pr_desconto_w			real;
vl_desconto_w			double precision;
vl_liquido_w			double precision;
ds_view_w			varchar(30);
qt_conta_desc_w			bigint;
ie_status_acerto_w		varchar(02);

qt_item_w			bigint;
qt_reg_w			bigint;

vl_desc_original_w		double precision;
vl_resumo_w			double precision;

ie_mais_desconto_w		varchar(01);
cd_estabelecimento_w		bigint;

ie_calculo_taxa_regra_w		varchar(01)	:= 'C';
nr_seq_regra_preco_w		bigint;
ds_nls_territory_w		varchar(64);
ie_tipo_item_w			varchar(1);
nr_seq_item_w			bigint;
qt_pacote_w			bigint;

vl_pacote_w			double precision;
nr_seq_proc_pacote_w		bigint;
vl_proc_pacote_w 		double precision;
vl_mat_pacote_w 		double precision;
vl_dif_pacote_w 		double precision;

C01 CURSOR FOR
	SELECT a.nr_sequencia,
		 b.ds_view
	from	conta_paciente_estrutura b,
		conta_paciente_desc_item a
	where a.cd_estrutura = b.cd_estrutura
	  and nr_seq_desconto = nr_sequencia_p
	  and ie_calcula = 'S'
	
union

	SELECT 	a.nr_sequencia,
		b.ds_view
	from	conta_paciente_estrutura b,
		conta_paciente_v c,
		conta_paciente_desc_item a
	where 	c.ie_emite_conta	= b.cd_estrutura
	and	a.nr_seq_desconto 	= nr_sequencia_p
	and	c.nr_interno_conta	= nr_interno_conta_w
	and	c.cd_setor_atendimento	= a.cd_setor_atendimento
	and	coalesce(a.cd_estrutura::text, '') = ''
	and 	a.ie_calcula 		= 'S';

C02 CURSOR FOR
	SELECT	nr_sequencia,
			CASE WHEN ie_proc_mat=1 THEN  'P'  ELSE 'M' END  ie_tipo_item
	from	conta_paciente_v
	where	nr_interno_conta = nr_interno_conta_w
	and 	coalesce(nr_seq_proc_pacote,0) = 0
	order by ie_proc_mat;

c03 CURSOR FOR
	SELECT	sum(vl_procedimento),
		nr_seq_proc_pacote
	from	procedimento_paciente
	where	nr_interno_conta	= nr_interno_conta_w
	and	nr_seq_proc_pacote	= nr_sequencia
	and	coalesce(cd_motivo_exc_conta::text, '') = ''
	group by nr_seq_proc_pacote;


BEGIN

select 	count(*)
into STRICT	qt_reg_w
from	conta_paciente_desc_item
where	nr_seq_desconto		= nr_sequencia_p;

if (qt_reg_w	= 0) then
	--r.aise_application_error(-20011,'Não existem itens para ser aplicado o desconto. Existem itens sem estrutura.');
	CALL wheb_mensagem_pck.exibir_mensagem_abort(263285);
end if;

select nr_interno_conta
into STRICT nr_interno_conta_w
from conta_paciente_desconto
where nr_sequencia = nr_sequencia_p;

select	ie_status_acerto,
	cd_estabelecimento
into STRICT	ie_status_acerto_w,
	cd_estabelecimento_w
from 	conta_paciente
where	nr_interno_conta	= nr_interno_conta_w;


ie_mais_desconto_w := Obter_Param_Usuario(67, 217, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_mais_desconto_w);


select	count(*)
into STRICT	qt_conta_desc_w
from 	conta_paciente_desconto
where	nr_interno_conta	= nr_interno_conta_w
and	(dt_calculo IS NOT NULL AND dt_calculo::text <> '');

select 	coalesce(sum(coalesce(b.vl_material,0)),0)
into STRICT		vl_desc_mat_w
FROM material_atend_paciente a
LEFT OUTER JOIN mat_atend_paciente_valor b ON (a.nr_sequencia = b.nr_seq_material)
WHERE nr_interno_conta 	= nr_interno_conta_w;


select 	coalesce(sum(coalesce(b.vl_procedimento,0)),0)
into STRICT		vl_desc_proc_w
FROM procedimento_paciente a
LEFT OUTER JOIN proc_paciente_valor b ON (a.nr_sequencia = b.nr_seq_Procedimento)
WHERE nr_interno_conta 	= nr_interno_conta_w   and a.nr_sequencia	<> coalesce(a.nr_seq_proc_pacote,0);

if (qt_conta_desc_w = 0) and (ie_acao_p = 'I') and
	((vl_desc_mat_w + vl_desc_proc_w) > 0) then
	begin

	delete 	from Proc_Paciente_valor b
	where 	b.ie_tipo_valor	= 3
	and	b.nr_seq_Procedimento in (SELECT	a.nr_sequencia
		from	procedimento_paciente a
		where	a.nr_interno_conta	= nr_interno_conta_w);

	delete 	from Mat_Atend_Paciente_valor b
	where 	b.ie_tipo_valor	= 3
	and	b.nr_seq_material in (SELECT	a.nr_sequencia
		from	material_atend_paciente a
		where	a.nr_interno_conta	= nr_interno_conta_w);


	select 	coalesce(sum(coalesce(b.vl_material,0)),0)
	into STRICT		vl_desc_mat_w
	FROM material_atend_paciente a
LEFT OUTER JOIN mat_atend_paciente_valor b ON (a.nr_sequencia = b.nr_seq_material)
WHERE nr_interno_conta 	= nr_interno_conta_w;


	select 	coalesce(sum(coalesce(b.vl_procedimento,0)),0)
	into STRICT	vl_desc_proc_w
	FROM procedimento_paciente a
LEFT OUTER JOIN proc_paciente_valor b ON (a.nr_sequencia = b.nr_seq_Procedimento)
WHERE nr_interno_conta 	= nr_interno_conta_w   and a.nr_sequencia	<> coalesce(a.nr_seq_proc_pacote,0);

	end;
end if;

if (ie_acao_p = 'I') and
	((vl_desc_mat_w + vl_desc_proc_w) > 0) and (ie_mais_desconto_w <> 'S') then
	--r.aise_application_error(-20011,'Já foi dado desconto !!!');
	CALL wheb_mensagem_pck.exibir_mensagem_abort(263284);
else
	begin

	if (ie_acao_p = 'E') then
		CALL Calcula_regra_tx_pck.set_calcula_regra_tx('N');
	end if;

	open C01;
	loop
		fetch C01 into	nr_sequencia_w,
					ds_view_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */

		if (position('PROCEDIMENTO' in ds_view_w) > 0) or (position('DIARIA' in ds_view_w) > 0) or (position('HONORARIO' in ds_view_w) > 0) then
			CALL Calcular_ConPaci_Desc_Proc(nr_sequencia_w, ie_acao_p, nm_usuario_p);
		elsif (position('MATERIAL' in ds_view_w) > 0) then
			CALL Calcular_ConPaci_Desc_Mat(nr_sequencia_w, ie_acao_p, nm_usuario_p);
		end if;
	end loop;
	close C01;

	if (ie_acao_p = 'E') then

		CALL Calcula_regra_tx_pck.set_calcula_regra_tx('S');

		select	coalesce(max(ie_calculo_taxa_regra),'C')
		into STRICT	ie_calculo_taxa_regra_w
		from	parametro_faturamento
		where	cd_estabelecimento	= cd_estabelecimento_w;

		if (ie_calculo_taxa_regra_w = 'L') then

			select  max(a.nr_sequencia)
			into STRICT	nr_seq_regra_preco_w
			from  	procedimento_paciente a,
				procedimento b,
				conta_paciente x
			where 	a.cd_procedimento  = b.cd_procedimento
			and 	a.ie_origem_proced = b.ie_origem_proced
			and 	x.nr_interno_conta = a.nr_interno_conta
			and	x.nr_interno_conta = nr_interno_conta_w
			and 	coalesce(a.nr_seq_proc_pacote::text, '') = ''
			and	coalesce(a.ie_valor_informado,'N') = 'N'
			and 	b.ie_classificacao <> 1
			and 	coalesce(a.nr_seq_regra_preco,0) > 0;

			if (coalesce(nr_seq_regra_preco_w,0) > 0) then
				CALL calcular_regra_preco_taxa(nr_interno_conta_w, nr_seq_regra_preco_w, 1, nm_usuario_p);
			end if;
		end if;

	end if;

	if (ie_acao_p = 'I') /*and  --Retirado esse tratamento para ie_status_acerto = 1 pois senão não funcionava para o desconto de protocolo  OS 227631
		(ie_status_acerto_w = '1') */
 then
		CALL Calcular_Conpaci_Dif_Total(nr_interno_conta_w, nr_sequencia_p, nm_usuario_p);
	end if;

	if (ie_acao_p = 'E') then
		open	c03;
		loop
		fetch	c03 into
			vl_pacote_w,
			nr_seq_proc_pacote_w;
		EXIT WHEN NOT FOUND; /* apply on c03 */
			begin

			select	coalesce(sum(vl_procedimento),0)
			into STRICT	vl_proc_pacote_w
			from	procedimento_paciente
			where	nr_seq_proc_pacote	= nr_seq_proc_pacote_w
			and	nr_sequencia		<> nr_seq_proc_pacote_w;

			select	coalesce(sum(vl_material),0)
			into STRICT	vl_mat_pacote_w
			from	material_atend_paciente
			where	nr_seq_proc_pacote	= nr_seq_proc_pacote_w;

			vl_dif_pacote_w	:= (vl_proc_pacote_w + vl_mat_pacote_w) - vl_pacote_w;

			if (vl_dif_pacote_w <> 0) then
				update	procedimento_paciente
				set	vl_procedimento	= vl_procedimento + vl_dif_pacote_w
				where	nr_sequencia	= nr_seq_proc_pacote_w;

			end if;

			end;
		end loop;
		close c03;
	end if;

	select	coalesce(max(a.vl_desconto),0)
	into STRICT	vl_desc_original_w
	from	conta_paciente_desconto a
	where	a.nr_interno_conta 	= nr_interno_conta_w;


	select	sum(vl_desconto)
	into STRICT	vl_resumo_w
	from	conta_paciente_resumo
	where	nr_interno_conta	= nr_interno_conta_w;

	if (vl_desc_original_w <> 0) and (vl_resumo_w	<> vl_desc_original_w) then
		select	max(nr_sequencia)
		into STRICT	nr_sequencia_w
		from	conta_paciente_resumo
		where	nr_interno_conta	= nr_interno_conta_w;

		update	conta_paciente_resumo
		set	vl_desconto		= vl_desconto + (vl_desc_original_w - vl_resumo_w)
		where	nr_interno_conta	= nr_interno_conta_w
		and	nr_sequencia		= nr_sequencia_w;
	end if;

	if (ie_acao_p = 'I') then
		/*Fabrício em  02/12/2008, no momento de dar o desconto o sistema não atualizava o campo VL_DESCONTO da função conta paciente, apenas era atualizado no momento de fechar a conta  (118941)   */

		/* Início Alteração */

		select	sum(vl_desconto)
		into STRICT	vl_desconto_w
		from (	SELECT 	coalesce(sum(b.vl_procedimento),0) vl_desconto
			from 	proc_paciente_valor b,
				procedimento_paciente a
			where 	a.nr_sequencia     = b.nr_seq_procedimento
			and 	b.ie_tipo_valor    = 3
			and 	a.nr_interno_conta = nr_interno_conta_w
			and 	a.nr_sequencia <> coalesce(a.nr_seq_proc_pacote,0)
			
union all

			SELECT coalesce(sum(b.vl_material),0)
			from	mat_atend_paciente_valor b,
				material_atend_paciente a
			where 	a.nr_sequencia     = b.nr_seq_material
			and 	b.ie_tipo_valor    = 3
			and 	a.nr_interno_conta = nr_interno_conta_w ) alias7;

		update	conta_paciente
		set	vl_desconto		= vl_desconto_w,
			nm_usuario		= nm_usuario_p,
			dt_atualizacao		= clock_timestamp()
		where	nr_interno_conta	= nr_interno_conta_w;
	end if;
	/* Fim alteração */

	update conta_paciente_desconto
	set	dt_calculo = CASE WHEN ie_acao_p='I' THEN  clock_timestamp()  ELSE null END ,
		nm_usuario = nm_usuario_p,
		dt_atualizacao = clock_timestamp()
	where nr_sequencia = nr_sequencia_p;

	/* Edgar 21/01/2004 - coloquei este update pq qdo desfazia o desconto não atualizava o vl_desconto na conta */

	if (ie_acao_p = 'E') then
		update	conta_paciente
		set	vl_desconto		 = NULL,
			nm_usuario		= nm_usuario_p,
			dt_atualizacao		= clock_timestamp()
		where	nr_interno_conta	= nr_interno_conta_w;
		/* Edgar 28/06/2004 - OS 9220 */

		delete	from conta_paciente_desconto
		where	nr_sequencia	= nr_sequencia_p;
	end if;

	if (2 = philips_param_pck.get_cd_pais) then

		open C02;
		loop
		fetch C02 into
			nr_seq_item_w,
			ie_tipo_item_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			begin

			CALL gerar_tributo_conta_pac(nr_interno_conta_w, nr_seq_item_w, ie_tipo_item_w, nm_usuario_p);

			end;
		end loop;
		close C02;

		select	count(1)
		into STRICT	qt_pacote_w
		from	procedimento_paciente
		where	nr_interno_conta	= nr_interno_conta_w
		and		nr_sequencia 		= nr_seq_proc_pacote;

		if	qt_pacote_w > 0 then

			CALL gerar_tributo_conta_pac(nr_interno_conta_w, 0, 'P', nm_usuario_p);

		end if;

	end if;

	if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;
	end;

end if;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE calcular_conpaci_desconto ( nr_sequencia_p bigint, ie_acao_p text, nm_usuario_p text) FROM PUBLIC;

