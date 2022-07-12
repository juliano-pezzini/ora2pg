-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_via_acesso_pck.pls_aplicar_via_acesso_conta ( dados_conta_p pls_via_acesso_pck.dados_conta, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: 
Rotina responsável por aplicar a regra de via de acesso, devido a demora no processo de homologação, e a grande gama de situações tratadas na mesma deverá ser tido um cuidado extremo ao alterar
qualquer ponto na mesma, após o término verificar a possíbilidade de válidar a alteração junto ao Rodrigo da UNIMED Litoral
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta: 
[  ]  Objetos do dicionário [  ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
dt_procedimento_w		pls_conta_proc_v.dt_procedimento_trunc%type;
dt_procedimento_ww		pls_conta_proc_v.dt_procedimento_trunc%type;
dt_inicio_proc_w		pls_conta_proc_v.hr_inicio_proc%type;
dt_inicio_proc_ww		pls_conta_proc_v.hr_inicio_proc%type;
dt_fim_proc_w			varchar(15);
nr_seq_regra_ww			varchar(255);
ie_simultaneo_w			varchar(255);
ie_via_acesso_inf_w		varchar(1)	:= 'S';
qt_minuto_w			bigint;
qt_item_ref_w			integer;
nr_seq_regra_w			pls_proc_via_acesso.nr_seq_regra%type;
ie_via_acesso_w			pls_proc_via_acesso.ie_via_acesso%type;
ie_via_acesso_temp_w		pls_proc_via_acesso.ie_via_acesso%type;
qt_proc_regra_w			pls_proc_via_acesso.qt_procedimento%type;
qt_proc_final_w			pls_proc_via_acesso.qt_proc_final%type;
cd_proc_regra_w			pls_proc_via_acesso.cd_procedimento%type;
ie_origem_proced_regra_w	pls_proc_via_acesso.ie_origem_proced%type;
ie_atu_via_acesso_padrao_w	boolean;
qt_pos_proc_w			integer;
nr_seq_conta_proc_w		pls_conta_proc_v.nr_sequencia%type;
cd_procedimento_w		pls_conta_proc_v.cd_procedimento%type;
ie_origem_proced_w		pls_conta_proc_v.ie_origem_proced%type;
qt_proc_conta_w			pls_proc_via_acesso.qt_procedimento%type;
tx_item_w			pls_conta_proc_v.tx_item%type;
ie_via_acesso_regra_w		pls_parametros.ie_via_acesso_regra%type;
cd_procedimento_ww		pls_conta_proc_v.cd_procedimento%type;
ie_origem_proced_ww		pls_conta_proc_v.ie_origem_proced%type;
nr_seq_proc_ref_w		pls_conta_proc_v.nr_seq_proc_ref%type;
ie_via_acesso_imp_w		pls_conta_proc_v.ie_via_acesso_imp%type;
ie_via_acesso_ww		pls_conta_proc_v.ie_via_acesso%type;
nr_seq_regra_proc_via_w		pls_conta_proc_v.nr_sequencia%type;
ie_via_acesso_ant_w		pls_conta_proc_v.ie_via_acesso%type;
nr_seq_regra_via_acesso_w	pls_proc_via_acesso.nr_sequencia%type;
ie_considerar_horario_w		pls_proc_via_acesso.ie_considerar_horario%type;
qt_horario_w			pls_proc_via_acesso.qt_horario%type;
ie_tipo_qt_horario_w		pls_proc_via_acesso.ie_tipo_qt_horario%type;

--Irá varer a regra
C00 CURSOR(nr_seq_regra_pc	pls_proc_via_acesso.nr_seq_regra%type)FOR
	SELECT	a.ie_via_acesso,
		coalesce(a.qt_procedimento,0) qt_procedimento,
		coalesce(a.qt_proc_final,9999999) qt_proc_final,
		a.cd_procedimento,
		a.ie_origem_proced,
		nr_sequencia,
		a.ie_considerar_horario,
		coalesce(a.qt_horario,0) qt_horario,
		a.ie_tipo_qt_horario
	from	pls_proc_via_acesso a
	where	a.nr_seq_regra = nr_seq_regra_pc
	order by coalesce(a.qt_procedimento,0),
		 coalesce(a.cd_procedimento,0);
		
--Irá varer os procedimentos que exigem via de acesso
C01 CURSOR(	cd_guia_referencia_pc		pls_conta_proc_v.cd_guia_referencia%type,
		nr_seq_segurado_pc		pls_conta_v.nr_seq_segurado%type)FOR
	SELECT	a.nr_sequencia,
		a.cd_procedimento,
		a.ie_origem_proced,
		a.qt_procedimento_imp,
		a.dt_procedimento_trunc,
		a.hr_inicio_proc,
		a.hr_fim_proc,
		a.nr_seq_proc_ref,
		a.ie_via_acesso_imp,
		a.ie_via_acesso,
		a.nr_seq_regra_via_acesso,
		(	SELECT	count(1)
			from	pls_conta_proc_v	c
			where	c.nr_seq_proc_ref	= a.nr_sequencia) qt_item_ref,
		nr_seq_conta
	from	pls_conta_proc_v	a
	where	a.cd_guia_referencia	= cd_guia_referencia_pc
	and	a.nr_seq_segurado	= nr_seq_segurado_pc
	and	a.ie_glosa		= 'N'
	and	a.ie_via_obrigatoria	= 'S'
	order by 
		dt_procedimento_trunc,
		hr_inicio_proc,
		nr_seq_proc_ref,
		qt_item_ref desc,
		nr_seq_conta,
		nr_sequencia,
		cd_procedimento,
		ie_origem_proced,
		hr_fim_proc;
		
C02 CURSOR(	nr_seq_conta_pc		pls_conta_proc_v.nr_seq_conta%type,
		nr_seq_segurado_pc	pls_conta_proc_v.nr_seq_segurado%type,
		cd_guia_referencia_pc	pls_conta_proc_v.cd_guia_referencia%type)FOR
	SELECT	a.nr_sequencia
	from	pls_conta_proc_v	a
	where	(a.nr_seq_regra_via_acesso IS NOT NULL AND a.nr_seq_regra_via_acesso::text <> '')
	and	exists (SELECT	1
			from	pls_conta_v x
			where 	x.nr_sequencia	= a.nr_seq_conta
			and	x.cd_guia_referencia = cd_guia_referencia_pc
			and	x.nr_seq_segurado = nr_seq_segurado_pc)
	and	exists ( select 1
			  from	pls_conta_proc_v y
			  where	y.nr_seq_conta 		= nr_seq_conta_pc
			  and	y.dt_procedimento_trunc	= a.dt_procedimento_trunc
			  and	y.ie_status		not in ('M','D')
			  and	y.ie_via_obrigatoria	= 'S')
	order by 1;
BEGIN
		
--Rotina responsável por verificar se todos os procedimentos da conta possuem uma regra de via de acesso válida. Caso 1 procedimento não possuir, não entra na regra de via de acesso. 
--Esta rotina retorna uma lista com todas as regra utilizadas na conta. 
nr_seq_regra_ww := pls_via_acesso_pck.pls_obtem_regra_via_acesso(dados_conta_p,nm_usuario_p);

select	ie_via_acesso_regra
into STRICT	ie_via_acesso_regra_w
from	table(pls_parametros_pck.f_retorna_param(cd_estabelecimento_p));

if (nr_seq_regra_ww IS NOT NULL AND nr_seq_regra_ww::text <> '') then

	--Rotina responsável por desmembrar os procedimentos da conta, ou seja, caso um procedimento possua qt. apresentada = 5, esta rotina irá criar 5 registros com quantidade apresentada 1
	pls_des_proced_via_acesso(	dados_conta_p, nr_seq_regra_ww, nm_usuario_p, cd_estabelecimento_p);
	
	--Irá varer as regras localizadas na rotina pls_obtem_regra_via_acesso
	while(length(nr_seq_regra_ww) > 0) loop
		begin
		-- faz o instr porque traz todas as regras de via de acesso separadas por vírgulas
		if (position(',' in nr_seq_regra_ww) > 0) then
			nr_seq_regra_w	:= (substr(nr_seq_regra_ww,1,position(',' in nr_seq_regra_ww) -1))::numeric;
			nr_seq_regra_ww	:= substr(nr_seq_regra_ww,position(',' in nr_seq_regra_ww) + 1,length(nr_seq_regra_ww));
		else
			nr_seq_regra_w	:= (nr_seq_regra_ww)::numeric;
			nr_seq_regra_ww	:= null;
		end if;
		
		for r_C00 in C00(nr_seq_regra_w) loop
			begin
			ie_via_acesso_w		:= r_C00.ie_via_acesso;
			qt_proc_regra_w		:= r_C00.qt_procedimento;
			qt_proc_final_w		:= r_C00.qt_proc_final;
			cd_proc_regra_w		:= r_C00.cd_procedimento;
			ie_origem_proced_regra_w:= r_C00.ie_origem_proced;
			nr_seq_regra_proc_via_w	:= r_C00.nr_sequencia;
			ie_considerar_horario_w	:= r_C00.ie_considerar_horario;
			qt_horario_w		:= r_C00.qt_horario;
			ie_tipo_qt_horario_w	:= r_C00.ie_tipo_qt_horario;
			
			qt_pos_proc_w	:= 0;
			if (ie_tipo_qt_horario_w = 'H') then
				qt_minuto_w := coalesce(qt_horario_w,0) * 60;
			elsif (ie_tipo_qt_horario_w = 'M') then
				qt_minuto_w := coalesce(qt_horario_w,0);
			end if;
			
			for r_C01 in C01(	dados_conta_p.cd_guia_referencia,
						dados_conta_p.nr_seq_segurado ) loop
				begin
				nr_seq_conta_proc_w	:= r_C01.nr_sequencia;
				cd_procedimento_w	:= r_C01.cd_procedimento;
				ie_origem_proced_w	:= r_C01.ie_origem_proced;
				qt_proc_conta_w		:= r_C01.qt_procedimento_imp;
				dt_procedimento_w	:= r_C01.dt_procedimento_trunc;
				dt_inicio_proc_w	:= r_C01.hr_inicio_proc;
				dt_fim_proc_w		:= r_C01.hr_fim_proc;
				nr_seq_proc_ref_w	:= r_C01.nr_seq_proc_ref;
				ie_via_acesso_imp_w	:= r_C01.ie_via_acesso_imp;
				ie_via_acesso_ww	:= r_C01.ie_via_acesso;
				nr_seq_regra_via_acesso_w:=r_C01.nr_seq_regra_via_acesso;
				qt_item_ref_w		:= r_C01.qt_item_ref;
				--Verifica se é possível atualizar a via de acesso dos procedimentos
				--não será possível atualizar quanto o procedimento for importado a partir de arquivo xml
				ie_via_acesso_inf_w := 'S';
				if (dados_conta_p.ie_origem_conta = 'E') and (coalesce(ie_via_acesso_regra_w,'N') = 'S') then
					if (coalesce(ie_via_acesso_ww,'X') = coalesce(ie_via_acesso_imp_w,'X')) then
						ie_via_acesso_inf_w	:= 'N';
					end if;
				end if;

				if ( ie_via_acesso_inf_w = 'N') or ( coalesce(ie_via_acesso_ww,'X') = 'X') or ( coalesce(ie_via_acesso_regra_w,'N') = 'N' ) or
					(nr_seq_regra_via_acesso_w IS NOT NULL AND nr_seq_regra_via_acesso_w::text <> '' AND ie_via_acesso_ww = 'U' )then
					begin
					--Irá verificar se o procedimento que está sendo verificado se encaixa na regra
					ie_simultaneo_w	:= pls_via_acesso_pck.pls_obter_conta_simul(dt_procedimento_w, dt_inicio_proc_w, dados_conta_p, nr_seq_regra_w);
					
					if (ie_simultaneo_w = 'S') then
						if (cd_procedimento_w	= cd_proc_regra_w) and (ie_origem_proced_w	= ie_origem_proced_regra_w) then
							--Irá ser realizada a leitura dos valores antigos para futura comparação
							--Criada a estrutura desta forma para os casos onde a regra for de 2 a 99 por exemplo. Sendo assim, o sistema apenas irá alterar a via de acesso a partir do 2 procedimento. 
							if (coalesce(dt_inicio_proc_ww::text, '') = '') then
								dt_inicio_proc_ww	:= dt_inicio_proc_w;
							end if;
							
							if (coalesce(dt_procedimento_ww::text, '') = '') then
								dt_procedimento_ww	:= dt_procedimento_w;
							end if;
							
							if (coalesce(cd_procedimento_ww::text, '') = '') then
								cd_procedimento_ww	:= cd_procedimento_w;
							end if;
							
							if (coalesce(ie_origem_proced_ww::text, '') = '') then
								ie_origem_proced_ww	:= ie_origem_proced_w;
							end if;
							--Ira verificar se já existe um procedimento executado no mesmo dia e hora caso já exista será acresentado mais um
							if (coalesce(cd_procedimento_w,0) = coalesce(cd_procedimento_ww,0)) and (coalesce(ie_origem_proced_w,0) = coalesce(ie_origem_proced_ww,0)) and
								(((coalesce(dt_inicio_proc_w,to_date('01/01/1900'))	= coalesce(dt_inicio_proc_ww,to_date('01/01/1900'))) and (coalesce(ie_considerar_horario_w,'S') = 'S')) or
								((pls_obter_minutos_intervalo(to_date(dt_inicio_proc_w,'hh24:mi:ss'),to_date(dt_inicio_proc_ww,'hh24:mi:ss'),qt_minuto_w) = 'S')and (ie_considerar_horario_w = 'N'))) and (coalesce(dt_procedimento_w,to_date('01/01/1900')) = coalesce(dt_procedimento_ww,to_date('01/01/1900'))) then
								if (coalesce(nr_seq_proc_ref_w::text, '') = '') then
									qt_pos_proc_w	:= qt_pos_proc_w + 1;
									
								end if;
							else
								qt_pos_proc_w	:= 1;
							end if;

							dt_procedimento_ww	:=  dt_procedimento_w;
							dt_inicio_proc_ww	:=  dt_inicio_proc_w;
							cd_procedimento_ww	:= cd_procedimento_w;
							ie_origem_proced_ww	:= ie_origem_proced_w;
							--Será verificado se a quantidade se encaixa na permitida pela via de acesso
							if (qt_pos_proc_w >= qt_proc_regra_w) and (qt_pos_proc_w <= qt_proc_final_w) then
								--Irá buscar a via de acesso informada na regra no caso de existir proc ref o procedimento irá receber o mesmo da regra
								ie_via_acesso_ant_w := ie_via_acesso_w;
								if (nr_seq_proc_ref_w IS NOT NULL AND nr_seq_proc_ref_w::text <> '') then
									
									select	max(ie_via_acesso)
									into STRICT	ie_via_acesso_temp_w
									from	pls_conta_proc
									where	nr_sequencia	= nr_seq_proc_ref_w;
									
									if (ie_via_acesso_temp_w IS NOT NULL AND ie_via_acesso_temp_w::text <> '') then
										ie_via_acesso_w	:= ie_via_acesso_temp_w;
									end if;
								end if;

								tx_item_w	:= obter_tx_proc_via_acesso(ie_via_acesso_w);
							
								update	pls_conta_proc
								set	ie_via_acesso		= ie_via_acesso_w,
									tx_item			= tx_item_w,
									nr_seq_regra_via_acesso	= nr_seq_regra_w
								where	nr_sequencia		= nr_seq_conta_proc_w;

							else
								ie_atu_via_acesso_padrao_w := true;
								--Irá atualizar a via de acesso com a via de acesso do procedimento referencia caso não encontrar será atualizado com via de acesso única e 100%
								if (nr_seq_proc_ref_w IS NOT NULL AND nr_seq_proc_ref_w::text <> '') then

									select	max(ie_via_acesso)
									into STRICT	ie_via_acesso_w
									from	pls_conta_proc
									where	nr_sequencia	= nr_seq_proc_ref_w;
									
									if (ie_via_acesso_w IS NOT NULL AND ie_via_acesso_w::text <> '') then
										tx_item_w	:= obter_tx_proc_via_acesso(ie_via_acesso_w);
										
										update	pls_conta_proc
										set	ie_via_acesso		= ie_via_acesso_w,
											tx_item			= tx_item_w,
											nr_seq_regra_via_acesso	= nr_seq_regra_w
										where	nr_sequencia		= nr_seq_conta_proc_w;
										-- seta para não atualizar com a taxa da via de acesso padrão
										ie_atu_via_acesso_padrao_w := false;
									end if;
								end if;
								
								-- se é para atualizar com taxa da via de acesso padrão
								if (ie_atu_via_acesso_padrao_w = true) then
									update	pls_conta_proc
									set	ie_via_acesso		= 'U',
										tx_item			= 100,
										nr_seq_regra_via_acesso	= nr_seq_regra_w
									where	nr_sequencia		= nr_seq_conta_proc_w
									and	coalesce(nr_seq_regra_via_acesso::text, '') = '';
								end if;

							end if;
							
							select	max(ie_via_acesso)
							into STRICT	ie_via_acesso_temp_w
							from	pls_proc_via_acesso
							where	nr_sequencia = nr_seq_regra_proc_via_w;
							
							if (ie_via_acesso_temp_w IS NOT NULL AND ie_via_acesso_temp_w::text <> '') then
								ie_via_acesso_w := ie_via_acesso_temp_w;
							end if;
						
						end if;
					end if;
					end;
				end if;
				
				end;
			end loop;
			
			end;
		end loop;
	end;
	end loop;
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_via_acesso_pck.pls_aplicar_via_acesso_conta ( dados_conta_p pls_via_acesso_pck.dados_conta, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;