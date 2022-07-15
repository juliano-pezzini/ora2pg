-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE fis_gerar_reg_b020_icmsipi ( nr_seq_controle_p bigint) AS $body$
DECLARE


-- VARIABLES
ie_gerou_dados_bloco_w 	varchar(1) := 'N';
nr_vetor_w		bigint	:= 0;
qt_cursor_w		bigint	:= 0;

nr_seq_icmsipi_B020_w	fis_efd_icmsipi_B020.nr_sequencia%type;
cd_sit_w		fis_efd_icmsipi_B020.cd_sit%type;
vl_cont_w		fis_efd_icmsipi_B020.vl_cont%type;
vl_isnt_iss_w		fis_efd_icmsipi_B020.vl_isnt_iss%type;
vl_iss_p_w		fis_efd_icmsipi_B020.vl_iss%type;
vl_bc_iss_p_w		fis_efd_icmsipi_B020.vl_bc_iss%type;
cd_mun_serv_w		fis_efd_icmsipi_B020.cd_mun_serv%type;
vl_bc_iss_rt_w		fis_efd_icmsipi_B020.vl_bc_iss_rt%type;
vl_iss_rt_w 		fis_efd_icmsipi_B020.vl_iss_rt%type;
dt_inicio_apuracao_w	fis_efd_icmsipi_controle.dt_inicio_apuracao%type;
dt_fim_apuracao_w	fis_efd_icmsipi_controle.dt_fim_apuracao%type;
nr_seq_modelo_nf_w	fis_efd_icmsipi_regra_B020.nr_seq_modelo_nf%type;
ie_tipo_data_w		fis_efd_icmsipi_regra_B020.ie_tipo_data%type;
cd_estabelecimento_w	fis_efd_icmsipi_controle.cd_estabelecimento%type;
cd_cgc_w		estabelecimento.cd_cgc%type;
cd_ver_w                fis_efd_icmsipi_controle.cd_ver%type;
cd_modelo_nf_w		modelo_nota_fiscal.cd_modelo_nf%type;
tipo_nota_w	        varchar(5);
ie_tipo_tributo_w   varchar(5);

-- USUARIO
nm_usuario_w			usuario.nm_usuario%type;

c_regras CURSOR FOR
	SELECT  trunc(a.dt_inicio_apuracao),
		trunc(a.dt_fim_apuracao),
		c.nr_seq_modelo_nf,
		c.ie_tipo_data,
		a.cd_estabelecimento,
		e.cd_cgc,
		a.cd_ver
	from  	fis_efd_icmsipi_controle   a,
		fis_efd_icmsipi_lote    b,
		fis_efd_icmsipi_regra_B020  c,
		estabelecimento     e
	where  	a.nr_seq_lote  		= b.nr_sequencia
	and   	b.nr_sequencia  	= c.nr_seq_lote
	and   	a.cd_estabelecimento 	= e.cd_estabelecimento
	and 	a.nr_sequencia 		= nr_seq_controle_p;

/*Cursor que retorna as informacoes para o registro B020*/

c_nota_fiscal CURSOR FOR
	SELECT	CASE WHEN obter_dados_operacao_nota(a.cd_operacao_nf, '6')='S' THEN  1  ELSE 0 END  cd_ind_oper,
		CASE WHEN obter_dados_operacao_nota(a.cd_operacao_nf, '6')='S' THEN  0 WHEN obter_dados_operacao_nota(a.cd_operacao_nf, '6')='E' THEN  CASE WHEN ie_tipo_nota='EP' THEN  0  ELSE 1 END  END  cd_ind_emit,
		CASE WHEN obter_dados_operacao_nota(a.cd_operacao_nf, '6')='E' THEN  coalesce(a.cd_cgc_emitente, a.cd_pessoa_fisica)  ELSE coalesce(cd_cgc,a.cd_pessoa_fisica) END  cd_part,
		lpad(b.cd_modelo_nf, 2, 0) cd_mod,
		a.cd_serie_nf cd_ser,
		a.nr_nota_fiscal nr_doc,
		trim(both a.nr_danfe) ds_chv_nfe,
		trunc(a.dt_emissao) dt_doc,
		null  cd_mun_serv, 
		a.vl_total_nota vl_cont,
		coalesce(a.vl_mat_terc,0) vl_mat_terc,
		coalesce(a.vl_sub,0) vl_sub,
		null vl_isnt_iss,
		0    vl_ded_bc,
		null vl_bc_iss,
		null vl_bc_iss_rt,
		null vl_iss_rt,
		null vl_iss,
		a.ie_status_envio, 	-- utilizado para a busca do codigo da situacao
		a.nr_sequencia nr_seq_nota
	FROM nota_fiscal a, operacao_nota_modelo d
LEFT OUTER JOIN modelo_nota_fiscal b ON (d.nr_seq_modelo = b.nr_sequencia)
WHERE a.cd_operacao_nf	= d.cd_operacao_nf  and (a.dt_atualizacao_estoque IS NOT NULL AND a.dt_atualizacao_estoque::text <> '') and (((ie_tipo_data_w = 1) and (trunc(a.dt_emissao) between dt_inicio_apuracao_w and dt_fim_apuracao_w)) 
		or ((ie_tipo_data_w = 2) and (trunc(a.dt_entrada_saida) between dt_inicio_apuracao_w and dt_fim_apuracao_w))) and (((obter_dados_operacao_nota(a.cd_operacao_nf, '6') = 'E') and 		-- Notas de Entrada
			(a.ie_status_envio IS NOT NULL AND a.ie_status_envio::text <> '') and  				-- Sem envio ao fisco
			(a.ie_situacao in (2,3,9)))                                   	-- Situacao 3- Estornada    2- Estorno - 9-Cancelada
		or ((obter_dados_operacao_nota(a.cd_operacao_nf, '6') = 'E') and   	-- Notas de Entrada
			(a.ie_situacao not in (2,3,9)))   			-- Situacao 3- Estornada    2- Estorno - 9-Cancelada
		or (obter_dados_operacao_nota(a.cd_operacao_nf, '6') = 'S' and  		-- Notas de saida
			(a.ie_status_envio IS NOT NULL AND a.ie_status_envio::text <> '') and
			a.ie_situacao <> 2)
		or (obter_dados_operacao_nota(a.cd_operacao_nf, '6') = 'S' and 
			coalesce(a.ie_status_envio::text, '') = '' and
			a.ie_situacao <> 2 and (exists (SELECT  1
					from	nfe_transmissao a,
						nfe_transmissao_nf b
					where	a.nr_sequencia = b.nr_seq_transmissao
					and	a.ie_tipo_nota = 'NFE'
					and 	a.ie_status_transmissao = 'T'
					and	b.nr_seq_nota_fiscal = a.nr_sequencia)))) and b.nr_sequencia		= nr_seq_modelo_nf_w and a.cd_estabelecimento	= cd_estabelecimento_w;	
	
/*Criacao do array com o tipo sendo do cursor especificado - C_NOTA_FISCAL */
	
type reg_c_nota_fiscal is table of c_nota_fiscal%RowType;
vet_c_nota_fiscal_w 			reg_c_nota_fiscal;

/*Criacao do array com o tipo sendo da tabela especificada - FIS_EFD_ICMSIPI_C170 */

type registro is table of fis_efd_icmsipi_B020%rowtype index by integer;
fis_registros_w			registro;

BEGIN

/*Obter o usuario ativo no tasy*/

nm_usuario_w := Obter_Usuario_Ativo;

open c_regras;
loop
fetch c_regras into	
	dt_inicio_apuracao_w,
	dt_fim_apuracao_w,
	nr_seq_modelo_nf_w,
	ie_tipo_data_w,
	cd_estabelecimento_w,
	cd_cgc_w,
	cd_ver_w;
EXIT WHEN NOT FOUND; /* apply on c_regras */
	begin
	if ((cd_ver_w)::numeric  >= 13) then
		open c_nota_fiscal;
		loop
		fetch c_nota_fiscal bulk collect into vet_c_nota_fiscal_w limit 1000;
			for i in 1..vet_c_nota_fiscal_w.Count loop
				begin
				if (coalesce(vet_c_nota_fiscal_w[i].ie_status_envio, 'XX') not in ('X','C','D')) then  --  Quando o campo 'ie_status_envio' for 'X','C' ou 'D' Nao gerar os registros filhos (C101, C110, C113, C114, C140, C141, C170, C190,
					fis_gerar_reg_B025_icmsipi(	nr_seq_controle_p,
									vet_c_nota_fiscal_w[i].nr_seq_nota);				
									
				end if;
				/*Limpeza de variavel*/

				cd_sit_w	:= null;
				vl_cont_w	:= null;
				vl_isnt_iss_w	:= null;
				vl_iss_p_w	:= null;
				vl_bc_iss_p_w	:= null;
				cd_mun_serv_w	:= null;
				vl_bc_iss_rt_w	:= null;
				vl_iss_rt_w 	:= null;
				
				/*Incrementa a variavel para o array*/

				qt_cursor_w:=	qt_cursor_w + 1;
				
				if (ie_gerou_dados_bloco_w = 'N') then
					ie_gerou_dados_bloco_w:=	'S';
				end if;
				
				begin
				
				/*Verificacao para encontrar  a situacao da nota*/

				if (coalesce(vet_c_nota_fiscal_w[i].ie_status_envio, 'XX') <> 'XX') then
					case vet_c_nota_fiscal_w[i].ie_status_envio
						when 'E' then
							cd_sit_w := '00';
						when 'C' then
							cd_sit_w := '02';
						when 'X' then
							cd_sit_w := '05';
						when 'D' then
							cd_sit_w := '04';
						else
							cd_sit_w := null;
					end case;
				else
					if (vet_c_nota_fiscal_w[i].cd_ind_oper = 0) then
					
						if (((vet_c_nota_fiscal_w[i].cd_ser)::numeric  >= 890) and ((vet_c_nota_fiscal_w[i].cd_ser)::numeric  <= 899)) then
							cd_sit_w :=	'08'; 						
						else
							cd_sit_w :=	'00';
						end if;
					end if;
				end if;
				
				exception
				when others then
					cd_sit_w :=	'00';
				end;
				
				begin
				/*Select para buscar os totalizadores do regintro c190*/

				select  CASE WHEN a.vl_cont=0 THEN  null  ELSE a.vl_cont END  		vl_cont,
					CASE WHEN a.vl_isnt_iss=0 THEN  null  ELSE a.vl_isnt_iss END  	vl_isnt_iss,
					CASE WHEN a.vl_iss_p=0 THEN  null  ELSE a.vl_iss_p END  	vl_iss_p,
					CASE WHEN a.vl_bc_iss_p=0 THEN  null  ELSE a.vl_bc_iss_p END  	vl_bc_iss_p
				into STRICT	vl_cont_w,
					vl_isnt_iss_w,
					vl_iss_p_w,
					vl_bc_iss_p_w
				from (
						SELECT 	coalesce(sum(vl_cont_p), 0) 		vl_cont,
							coalesce(sum(vl_isnt_iss_p), 0) 	vl_isnt_iss,
							coalesce(sum(vl_iss_p), 0) 		vl_iss_p,
							coalesce(sum(vl_bc_iss_p), 0) 	vl_bc_iss_p
						from 	fis_efd_icmsipi_b025 a
						where 	a.nr_seq_nota = 	vet_c_nota_fiscal_w[i].nr_seq_nota
						and 	a.nr_seq_controle = 	nr_seq_controle_p
					) a;

				exception
				when others then
					vl_cont_w	:= null;
					vl_isnt_iss_w	:= null;
					vl_iss_p_w	:= null;
					vl_bc_iss_p_w	:= null;
				end;
				
				
				  -- Call the function
				cd_mun_serv_w := obter_dados_pf_pj(	cd_pessoa_fisica_p => null,
									cd_cgc_p => cd_cgc_w,
									ie_opcao_p => 'CDMDV');
				
				select 	obter_dados_operacao_nota(cd_operacao_nf, '6')
                		into STRICT tipo_nota_w
				from 	nota_fiscal
				where 	nr_sequencia = vet_c_nota_fiscal_w[i].nr_seq_nota;

				if ( tipo_nota_w = 'S') then
                	ie_tipo_tributo_w := 'ISSST';
                else
                	ie_tipo_tributo_w := 'ISS';
                end if;

				vl_bc_iss_rt_w	:= obter_valor_tipo_tributo_nota(  	nr_seq_nota_p 		=> vet_c_nota_fiscal_w[i].nr_seq_nota,
											ie_tipo_valor_p 	=> 'B',
											ie_tipo_tributo_p 	=> ie_tipo_tributo_w);

				if vet_c_nota_fiscal_w[i].cd_mod <> '65' then
					vl_iss_rt_w	:= obter_valor_tipo_tributo_nota(  	nr_seq_nota_p 		=> vet_c_nota_fiscal_w[i].nr_seq_nota,
												ie_tipo_valor_p 	=> 'V',
												ie_tipo_tributo_p 	=> ie_tipo_tributo_w);
				else
					vl_iss_rt_w	:= 0;
				end if;
											
				--Buscar nos dados adicionais a especie da nota fiscal
				select coalesce(max(m.cd_modelo_nf), vet_c_nota_fiscal_w[i].cd_mod)
				into STRICT cd_modelo_nf_w
				from nota_fiscal n,
					 modelo_nota_fiscal m
				where n.nr_sequencia = vet_c_nota_fiscal_w[i].nr_seq_nota
				and n.nr_seq_modelo = m.nr_sequencia;
				
				/*Busca da sequencia da tabela especificada - fis_efd_icmsipi_B020 */

				select	nextval('fis_efd_icmsipi_b020_seq')
				into STRICT	nr_seq_icmsipi_B020_w
				;
				
				/*Inserindo valores no array para realizacao do forall posteriormente*/

				fis_registros_w[qt_cursor_w].nr_sequencia		:= nr_seq_icmsipi_B020_w;
				fis_registros_w[qt_cursor_w].dt_atualizacao		:= clock_timestamp();
				fis_registros_w[qt_cursor_w].nm_usuario			:= nm_usuario_w;
				fis_registros_w[qt_cursor_w].dt_atualizacao_nrec	:= clock_timestamp();
				fis_registros_w[qt_cursor_w].nm_usuario_nrec		:= nm_usuario_w;
				fis_registros_w[qt_cursor_w].cd_reg             	:= 'B020';
				fis_registros_w[qt_cursor_w].cd_ind_oper		:= vet_c_nota_fiscal_w[i].cd_ind_oper;
				fis_registros_w[qt_cursor_w].cd_ind_emit		:= vet_c_nota_fiscal_w[i].cd_ind_emit;
				fis_registros_w[qt_cursor_w].cd_mod			:= cd_modelo_nf_w;
				fis_registros_w[qt_cursor_w].cd_sit			:= cd_sit_w;
				fis_registros_w[qt_cursor_w].cd_ser			:= substr(vet_c_nota_fiscal_w[i].cd_ser,1,3); /*RETIRAR O SUBSTR E FALAR COM RICARDO PARA VERIFICAR O CAMPO, 3 - 5*/
				fis_registros_w[qt_cursor_w].nr_doc             	:= substr(vet_c_nota_fiscal_w[i].nr_doc,1,9); /*RETIRAR O SUBSTR E FALAR COM RICARDO PARA VERIFICAR O CAMPO. 9 - 255*/
				
				if coalesce(vet_c_nota_fiscal_w[i].ie_status_envio,'XX') <> 'X' then  --  Quando o campo 'ie_status_envio' for 'X', preencher somente os campos 'REG', 'IND_OPER', 'IND_EMIT', 'COD_MOD', 'COD_SIT',' SER', e 'NUM_DOC'.
					fis_registros_w[qt_cursor_w].ds_chv_nfe         := substr(replace(vet_c_nota_fiscal_w[i].ds_chv_nfe, ' ', ''),1,44); /*Verificar o tamanho da chave da NF-e */
				end if;
				
				if (coalesce(vet_c_nota_fiscal_w[i].ie_status_envio, 'XX') not in ('X','C','D')) then  --  Quando o campo 'ie_status_envio' for 'X','C' ou 'D' Nao gerar os registros filhos (C101, C110, C113, C114, C140, C141, C170, C190,
					fis_registros_w[qt_cursor_w].cd_part		:= vet_c_nota_fiscal_w[i].cd_part;
					fis_registros_w[qt_cursor_w].dt_doc             := vet_c_nota_fiscal_w[i].dt_doc;				
					--fis_registros_w(qt_cursor_w).cod_inf_obs	:= vet_c_nota_fiscal_w(i).cd_obs;
					fis_registros_w[qt_cursor_w].cd_mun_serv	:= cd_mun_serv_w;
					fis_registros_w[qt_cursor_w].vl_cont		:= coalesce(vl_cont_w,0);
					fis_registros_w[qt_cursor_w].vl_mat_terc	:= coalesce(vet_c_nota_fiscal_w[i].vl_mat_terc,0);
					fis_registros_w[qt_cursor_w].vl_sub		:= coalesce(vet_c_nota_fiscal_w[i].vl_sub,0);
					fis_registros_w[qt_cursor_w].vl_isnt_iss	:= coalesce(vl_isnt_iss_w,0);
					fis_registros_w[qt_cursor_w].vl_ded_bc		:= coalesce(vet_c_nota_fiscal_w[i].vl_ded_bc,0);
					fis_registros_w[qt_cursor_w].vl_bc_iss		:= coalesce(vl_bc_iss_p_w,0);
					fis_registros_w[qt_cursor_w].vl_bc_iss_rt	:= coalesce(vl_bc_iss_rt_w,0);
					fis_registros_w[qt_cursor_w].vl_iss_rt		:= coalesce(vl_iss_rt_w,0);
					fis_registros_w[qt_cursor_w].vl_iss		:= coalesce(vl_iss_p_w,0);
				end if;
				
				fis_registros_w[qt_cursor_w].nr_seq_nota		:= vet_c_nota_fiscal_w[i].nr_seq_nota;
				fis_registros_w[qt_cursor_w].nr_seq_controle    	:= nr_seq_controle_p;
				
				if (nr_vetor_w >= 1000) then
					/*Inserindo registros definitivamente na tabela especifica - FIS_EFD_ICMSIPI_B020 */

					forall j in fis_registros_w.first..fis_registros_w.last
						insert into fis_efd_icmsipi_B020 values fis_registros_w(j);

					nr_vetor_w	:= 0;
					fis_registros_w.delete;

					commit;
				end if;
				
				/*incrementa variavel para realizar o forall quando chegar no valor limite*/

				nr_vetor_w	:= nr_vetor_w 	+ 1;
				
				end;
			end loop;
		EXIT WHEN NOT FOUND; /* apply on c_nota_fiscal */
		end loop;
		close c_nota_fiscal;

	end if;
	end;
end loop;
close c_regras;

if (fis_registros_w.count > 0) then
	/*Inserindo registro que nao entraram outro for all devido a quantidade de registros no vetor*/

	forall l in fis_registros_w.first..fis_registros_w.last
		insert into fis_efd_icmsipi_B020 values fis_registros_w(l);
		
	fis_registros_w.delete;

	commit;
end if;

/*Libera memoria*/

dbms_session.free_unused_user_memory;

/*Atualizacao informacao no controle de geracao de registro para SIM*/

if (ie_gerou_dados_bloco_w = 'S') then
	update 	fis_efd_icmsipi_controle
	set		ie_mov_B = 'S'
	where 	nr_sequencia = nr_seq_controle_p;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE fis_gerar_reg_b020_icmsipi ( nr_seq_controle_p bigint) FROM PUBLIC;

