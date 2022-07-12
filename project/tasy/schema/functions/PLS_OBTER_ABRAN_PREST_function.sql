-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_abran_prest ( nr_seq_prestador_p pls_prestador.nr_sequencia%type, nr_seq_segurado_p pls_segurado.nr_sequencia%type, nr_seq_outorgante_p pls_outorgante.nr_sequencia%type, nr_seq_plano_p pls_plano.nr_sequencia%type, ie_tipo_segurado_p pls_segurado.ie_tipo_segurado%type, dt_emissao_p timestamp, ie_abrangencia_p pls_plano.ie_abrangencia%type) RETURNS varchar AS $body$
DECLARE

					
/*compara a abrangência do prestador com a abrangência do produto do beneficiário. Se for informado a área de atuação utilizará ela, caso contrário seguirá o processo descrito abaixo.

Para a abrangência municipal do produto, o município do prestador deve ser o mesmo da  cooperativa/operadora do beneficiário.
Já para uma abrangência estadual, o estado do prestador  deve ser o mesmo da  cooperativa/operadora do beneficiário.
Para a nacional, ambas devem estar dentro do mesmo país.
Para este tipo de processo  poderão ser utilizadas todas as abrangências descritas no PTU. Se for utilizada alguma referente a grupos, obrigatoriamente deve ser informado a área de atuação.*/
					
qt_area_atuacao_w		integer;
qt_benef_repas_val_w		integer;
ie_area_coberta_w		varchar(1);		
ie_tipo_prestador_w		varchar(2);
cd_cogido_prestador_w		varchar(22);
nr_seq_pais_prestador_w		pais.nr_sequencia%type;
nr_seq_pais_outorgante_w	pais.nr_sequencia%type;
cd_cgc_outorgante_w		pls_outorgante.cd_cgc_outorgante%type;
sg_estado_prest_w		pls_prestador_area.sg_estado%type;		

/* Áreas de atuação do plano */

c01 CURSOR(nr_seq_plano_p	pls_plano.nr_sequencia%type) FOR
	SELECT	a.cd_municipio_ibge,
		a.sg_estado,
		a.nr_seq_regiao
	from	pls_plano_area a
	where	a.nr_seq_plano	= nr_seq_plano_p;

	
/*Área de atuação do prestador executor */

C02 CURSOR(nr_seq_prestador_p	pls_prestador.nr_sequencia%type) FOR
	SELECT	a.cd_municipio_ibge,
		a.sg_estado,
		a.nr_seq_regiao
	from	pls_prestador_area a
	where	a.nr_seq_prestador	= nr_seq_prestador_p;
	
/* Áreas de atuação da operadora */

c03 CURSOR(nr_seq_outorgante_p	pls_outorgante.nr_sequencia%type) FOR
	SELECT	a.cd_municipio_ibge,
		a.sg_uf_municipio,
		a.nr_seq_regiao
	from	pls_regiao_atuacao a
	where	a.nr_seq_operadora	= nr_seq_outorgante_p;
BEGIN

/*Se não consistir nada abaixo, irá retornar que não tem abrangência por padrão. Princípio da pior situação*/

ie_area_coberta_w	:= 'N';
qt_benef_repas_val_w	:= 1;
-- verificação de segurança
if ((ie_abrangencia_p IS NOT NULL AND ie_abrangencia_p::text <> '') and (nr_seq_prestador_p IS NOT NULL AND nr_seq_prestador_p::text <> '') and (nr_seq_plano_p IS NOT NULL AND nr_seq_plano_p::text <> ''))	then
	
	if (ie_tipo_segurado_p = 'C')	then
		qt_benef_repas_val_w	:= 0;
	/*Verifica a validade do repasse de responsabilidade assumida*/

		select	count(1)
		into STRICT	qt_benef_repas_val_w
		from 	pls_segurado
		where 	nr_sequencia = nr_seq_segurado_p
		and	dt_emissao_p between dt_contratacao and dt_rescisao
		or (dt_emissao_p >= dt_contratacao and coalesce(dt_rescisao::text, '') = '')  LIMIT 1;
	
	end if;
	
	/*Verificar se no sistema está informado a area de atuação do produto*/

	select	count(1)
	into STRICT	qt_area_atuacao_w
	from	pls_plano_area	a
	where	a.nr_seq_plano = nr_seq_plano_p;
	
	if (qt_benef_repas_val_w > 0)	then
		
		/*Se a abrangência for diferente de nacional*/

		if (ie_abrangencia_p <> 'N')	then
			/*Se houver área de atuação informada para o plano*/

			if (qt_area_atuacao_w > 0) then
				
				for r_c01 in C01(nr_seq_plano_p) loop/*informações do plano r_C01*/
				

				
					for r_C02 in C02(nr_seq_prestador_p) loop/*informações do prestador executor do atendimento r_c02*/

									
						
									
									
						/*Compara o municipio do plano com o municipio do prestador*/

						if (ie_abrangencia_p = 'M')	then
							if (r_c01.cd_municipio_ibge = r_c02.cd_municipio_ibge)	then
					
								ie_area_coberta_w  := 'S';
								return ie_area_coberta_w;
							end if;			
						/*Compara a abrangência estadual, estado do plano com o estado do prestador */

						elsif (ie_abrangencia_p = 'E')	then
							if (r_c01.sg_estado = r_c02.sg_estado)	then					
								ie_area_coberta_w := 'S';
								return ie_area_coberta_w;							
							/* verifica se o estado cadastrado na área de atuação do plano pertence a região cadastrada na área de atuação do prestador */

							elsif (pls_obter_se_mun_uf_regiao(null, r_c01.sg_estado, r_c02.nr_seq_regiao) = 'S') then
								ie_area_coberta_w := 'S';
								return ie_area_coberta_w;
							/* verifica se o estado cadastrado na área de atuação do prestador pertence a região cadastrada na área de atuação do plano */

							elsif (pls_obter_se_mun_uf_regiao(null, r_c02.sg_estado, r_c01.nr_seq_regiao) = 'S') then
								ie_area_coberta_w := 'S';
								return ie_area_coberta_w;
							/* verifica se o município cadastrado na área de atuação do plano pertence ao estado cadastrado na área de atuação do prestador */

							elsif ((coalesce(r_c01.sg_estado::text, '') = '') and (pls_obter_se_municipio_em_uf(r_c01.cd_municipio_ibge, r_c02.sg_estado)	= 'S')) then
								ie_area_coberta_w := 'S';
								return ie_area_coberta_w;							
							/* verifica se o município cadastrado na área de atuação do prestador pertence ao estado cadastrado na área de atuação do plano */

							elsif ((coalesce(r_c02.sg_estado::text, '') = '') and (pls_obter_se_municipio_em_uf(r_c02.cd_municipio_ibge, r_c01.sg_estado)	= 'S')) then
								ie_area_coberta_w := 'S';
								return ie_area_coberta_w;
							end if;
						elsif (ie_abrangencia_p = 'GM')	then/*Grupo de múnicipios*/
							if (r_c01.nr_seq_regiao = r_c02.nr_seq_regiao) then
								ie_area_coberta_w	:= 'S';
								return ie_area_coberta_w;
								
							elsif (r_c01.sg_estado = r_c02.sg_estado)	then					
								ie_area_coberta_w := 'S';
								return ie_area_coberta_w;

							/*Se o município do prestador está  na região do plano*/

							elsif (pls_obter_se_mun_uf_regiao(r_c02.cd_municipio_ibge, null, r_c01.nr_seq_regiao) = 'S') then
								ie_area_coberta_w	:= 'S';
								return ie_area_coberta_w;

							/*Se o município  do plano está na região do prestador*/

							elsif (pls_obter_se_mun_uf_regiao(r_c01.cd_municipio_ibge, null, r_c02.nr_seq_regiao) = 'S') then
								ie_area_coberta_w	:= 'S';
								return ie_area_coberta_w;
								
							/*Se o estado do prestador está  na região do plano*/

							elsif (pls_obter_se_mun_uf_regiao(null, r_c02.sg_estado, r_c01.nr_seq_regiao) = 'S') then
								ie_area_coberta_w	:= 'S';
								return ie_area_coberta_w;

							/*Se o município do plano está no estado do prestador*/

							elsif (pls_obter_se_municipio_em_uf(r_c01.cd_municipio_ibge, r_c02.sg_estado)	= 'S') then
								ie_area_coberta_w	:= 'S';
								return ie_area_coberta_w;

							/*Se o município do prestador está no estado do plano*/

							elsif (pls_obter_se_municipio_em_uf(r_c02.cd_municipio_ibge, r_c01.sg_estado)	= 'S') then
								ie_area_coberta_w	:= 'S';
								return ie_area_coberta_w;

							elsif (r_c01.cd_municipio_ibge = r_c02.cd_municipio_ibge) then
								ie_area_coberta_w	:= 'S';
								return ie_area_coberta_w;
							end if;
							
						-- se for por grupo de estados. Nesse caso, presume-se que as regiões estejam cadastradas por estados e não por municípios.
						elsif (ie_abrangencia_p = 'GE')	then
							
							-- Se no cadastro do prestador não estiver informado a UF e sim a cidade, então busca a UF na qual essa cidade faz parte
							if (coalesce(r_c02.sg_estado::text, '') = '') then
								sg_estado_prest_w := obter_uf_ibge(r_c02.cd_municipio_ibge);
							else
								sg_estado_prest_w := r_c02.sg_estado;
							end if;
							
							if (r_c01.nr_seq_regiao = r_c02.nr_seq_regiao) then
								ie_area_coberta_w	:= 'S';
								return ie_area_coberta_w;
							
							/*Se o estado do município do plano está na região do prestador*/

							elsif (pls_obter_se_mun_uf_regiao(null, obter_uf_ibge(r_c01.cd_municipio_ibge), r_c02.nr_seq_regiao) = 'S') then
								ie_area_coberta_w	:= 'S';
								return ie_area_coberta_w;

							/*Se o estado do município do prestador está na região do plano*/

							elsif (pls_obter_se_mun_uf_regiao(null, obter_uf_ibge(r_c02.cd_municipio_ibge), r_c01.nr_seq_regiao) = 'S') then
								ie_area_coberta_w	:= 'S';
								return ie_area_coberta_w;							

							/*Se o  estado da  prestador está na região do plano*/
		
							elsif (pls_obter_se_mun_uf_regiao(null, sg_estado_prest_w ,r_c01.nr_seq_regiao) = 'S') then
								ie_area_coberta_w	:= 'S';
								return ie_area_coberta_w;
								
							/*Se  o estado do plano está na região do perstador*/

							elsif (pls_obter_se_mun_uf_regiao(null,r_c01.sg_estado ,r_c02.nr_seq_regiao) = 'S') then
								ie_area_coberta_w	:= 'S';
								return ie_area_coberta_w;
							end if;
						end if;
					end loop;
				end loop;
				
			-- Informação da operadora que recebeu a conta do prestador
			elsif (nr_seq_outorgante_p IS NOT NULL AND nr_seq_outorgante_p::text <> '')	then
				
				for r_c03 in C03(nr_seq_outorgante_p) loop/*informações da operadora  outorgante r_c03*/
					for r_C02 in C02(nr_seq_prestador_p) loop/*informações da prestador executor do atendimento r_c02*/
						ie_area_coberta_w	:= 'S';
						/*Compara o municipio da operadora com o municipio do prestador*/

						if (ie_abrangencia_p = 'M')	then
							if (r_c03.cd_municipio_ibge = r_c02.cd_municipio_ibge)	then
								ie_area_coberta_w  := 'S';
								return ie_area_coberta_w;
							end if;
						/*Compara a abrangência estadual, compara estado da operadora com o estado do prestador */

						elsif (ie_abrangencia_p = 'E')	then
							if (r_c03.sg_uf_municipio = r_c02.sg_estado)	then
								ie_area_coberta_w := 'S';
								return ie_area_coberta_w;
							end if;
						end if;
					end loop;
				end loop;
			end if;
		elsif (ie_abrangencia_p = 'N')	then /*Se a abrangência for nacional*/

			/*Obter se o prestador é PF ou PJ*/

			select	CASE WHEN coalesce(max(a.cd_cgc)::text, '') = '' THEN  'PF'  ELSE 'PJ' END
			into STRICT	ie_tipo_prestador_w
			from	pls_prestador	a
			where	a.nr_sequencia = nr_seq_prestador_p;
			
			/*Buscar o CGC do outorgante*/

			select 	max(x.cd_cgc_outorgante)
			into STRICT	cd_cgc_outorgante_w
			from	pls_outorgante	x
			where	x.nr_sequencia = nr_seq_outorgante_p;
				
			/*Se o tipo de prestador for pessoa física buscará o país da tabela PESSOA_FISICA*/

			if (ie_tipo_prestador_w	= 'PF')	then
				/*Buscar o  do prestador*/

				select	max(x.cd_pessoa_fisica)
				into STRICT 	cd_cogido_prestador_w
				from	pls_prestador	x
				where	x.nr_sequencia = nr_seq_prestador_p;
				
			/*Se o tipo de prestador for pessoa jurídica buscará o país da tabela PESSOA_JURIDICA*/

			elsif (ie_tipo_prestador_w	= 'PJ')	then
				select	max(x.cd_cgc)
				into STRICT 	cd_cogido_prestador_w
				from	pls_prestador	x
				where	x.nr_sequencia = nr_seq_prestador_p;
				
			end if;
			
			/*Buscar os países*/

			nr_seq_pais_prestador_w		:= pls_obter_pais_abrang(cd_cogido_prestador_w,ie_tipo_prestador_w);
			nr_seq_pais_outorgante_w	:= pls_obter_pais_abrang(cd_cgc_outorgante_w,'PJ');
			
			
			
			/*Conforme visto com Décio,  se não encontrar valor para o país do prestador não irá validar a glosa DRQUADROS  O.S 604052*/

			if (nr_seq_pais_prestador_w is  not null)	then
				if (nr_seq_pais_prestador_w = nr_seq_pais_outorgante_w)	then
					ie_area_coberta_w := 'S';
					return ie_area_coberta_w;
				end if;
			else
				ie_area_coberta_w	:= 'S';
				return ie_area_coberta_w;
			end if;
		end if;

	end if;
end if;
return ie_area_coberta_w;	

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_abran_prest ( nr_seq_prestador_p pls_prestador.nr_sequencia%type, nr_seq_segurado_p pls_segurado.nr_sequencia%type, nr_seq_outorgante_p pls_outorgante.nr_sequencia%type, nr_seq_plano_p pls_plano.nr_sequencia%type, ie_tipo_segurado_p pls_segurado.ie_tipo_segurado%type, dt_emissao_p timestamp, ie_abrangencia_p pls_plano.ie_abrangencia%type) FROM PUBLIC;
