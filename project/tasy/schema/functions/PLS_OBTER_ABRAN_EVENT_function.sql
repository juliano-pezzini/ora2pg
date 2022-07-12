-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_abran_event ( nr_seq_prestador_p pls_prestador.nr_sequencia%type, nr_seq_segurado_p pls_segurado.nr_sequencia%type, nr_seq_cooperativa_p pls_congenere.nr_sequencia%type, nr_seq_plano_p pls_plano.nr_sequencia%type, ie_abrangencia_p pls_plano.ie_abrangencia%type) RETURNS varchar AS $body$
DECLARE

/* 
Está rotina irá consistir a abrangencia para usuários eventuais da seguinte forma. 
 
O sistema compara a abrangência da operadora congênere ou prestador com a abrangência da cooperativa/operadora do beneficiário. Neste caso é possível termos apenas três abrangências: municipal, estadual e nacional. 
Para a abrangência municipal do produto, o município do prestador deve ser o mesmo da cooperativa/operadora do beneficiário. 
Já para uma abrangência estadual do produto, o estado do prestador deve ser o mesmo da cooperativa/operadora do beneficiário. 
Para a nacional, ambas devem estar dentro do mesmo país. 
*/
 
 
nr_seq_pais_prestador_w		pais.nr_sequencia%type;
nr_seq_pais_cooperativa_w	pais.nr_sequencia%type;
nr_seq_congenere_seg_w		pls_congenere.nr_sequencia%type;
cd_cgc_congenere_w		pls_congenere.cd_cgc%type;
cd_codigo_prestador_w		varchar(20);
ie_area_coberta_w		varchar(1);
ie_tipo_prestador_w		varchar(2);

C01 CURSOR(nr_seq_prestador_p	pls_prestador.nr_sequencia%type) FOR 
	/*Buscar a informação do prestador que atendeu o beneficiário*/
 
	SELECT	a.cd_municipio_ibge, 
		a.sg_estado, 
		a.nr_seq_regiao 
	from	pls_prestador_area a 
	where	a.nr_seq_prestador	= nr_seq_prestador_p;

	 
C02 CURSOR(nr_seq_cooperativa_p pls_congenere.nr_sequencia%type) FOR 
	/*Buscar a informação da cooperativa do atendimento*/
 
	SELECT	a.cd_municipio_ibge, 
		a.sg_estado, 
		a.nr_seq_regiao 
	from	pls_cooperativa_area	a 
	where	a.nr_seq_cooperativa	= nr_seq_cooperativa_p;
BEGIN
/*Se não consistir nada abaixo, irá retornar que não tem abrangência por padrão. Princípio da pior situação*/
 
ie_area_coberta_w	:= 'N';
 
if (ie_abrangencia_p IS NOT NULL AND ie_abrangencia_p::text <> '')	then 
	/*Buscar a informação da congenere do segurado*/
 
	nr_seq_congenere_seg_w	:= pls_obter_dados_segurado(nr_seq_segurado_p,'NRCON');	
	 
	/*Se a abrangência for diferente de nacional*/
 
	if (ie_abrangencia_p <> 'N')	then 
		/*Se estiver comparando o prestador*/
 
		if (nr_seq_prestador_p IS NOT NULL AND nr_seq_prestador_p::text <> '')	then 
			 
			for r_c01 in C01(nr_seq_prestador_p) loop		/*Informações do prestador executor r_C01*/
 
				for r_c02 in C02(nr_seq_congenere_seg_w) loop	/*informações da coopertiva do benef r_C02*/
 
				 
					/*Compara a abrangência municípal, cidade do prestador com a cidade da cooperativa do beneficiário */
 
					if (ie_abrangencia_p = 'M')	then 
					 
						if (r_c01.cd_municipio_ibge = r_c02.cd_municipio_ibge)	then 
							ie_area_coberta_w := 'S';			
						end if;			
					 
					/*Compara a abrangência estadual, estado do prestador com o estado da cooperativa do beneficiário */
 
					elsif (ie_abrangencia_p = 'E')	then 
						if (r_c01.sg_estado = r_c02.sg_estado)	then 
							ie_area_coberta_w := 'S';
						end if;
					end if;
					 
				end loop;
			end loop;
			 
		/*Se estiver comparando com uma cooperativa*/
 
		elsif (nr_seq_cooperativa_p IS NOT NULL AND nr_seq_cooperativa_p::text <> '')	then 
		 
			for r_c02_1 in C02(nr_seq_cooperativa_p) loop		/*Informações da cooperativa r_C03*/
 
				for r_c02_2 in C02(nr_seq_congenere_seg_w) loop	/*informações da coopertiva do benef r_C02*/
 
		 
					/*Compara a abrangência municipal, cidade do cooperativa atend com a cidade da cooperativa do beneficiário */
 
					if (ie_abrangencia_p = 'M')	then 
						if (r_c02_2.cd_municipio_ibge = r_c02_1.cd_municipio_ibge)	then 
							ie_area_coberta_w := 'S';			
						end if;			
					 
					/*Compara a abrangência estadual, estado do cooperativa atend com o estado da cooperativa do beneficiário */
 
					elsif (ie_abrangencia_p = 'E')	then 
						if (r_c02_2.sg_estado = r_c02_1.sg_estado)	then 
							ie_area_coberta_w := 'S';
						end if;
					end if;
					 
				end loop;
			end loop;
			 
		end if;
	/*Consistência para abrangência nacional*/
 
	elsif (ie_abrangencia_p = 'N')	then 
		/*Se estiver comparando o prestador*/
 
		if (nr_seq_prestador_p IS NOT NULL AND nr_seq_prestador_p::text <> '')	then 
			/*Buscar o país da outorgante*/
 
			select	max(x.cd_cgc) 
			into STRICT  cd_cgc_congenere_w 
			from	pls_congenere	x 
			where	x.nr_sequencia = nr_seq_congenere_seg_w;
			 
			/*Obter se o prestador é PF ou PJ*/
 
			select	CASE WHEN coalesce(max(a.cd_cgc)::text, '') = '' THEN  'PF'  ELSE 'PJ' END  
			into STRICT	ie_tipo_prestador_w 
			from	pls_prestador	a 
			where	a.nr_sequencia = nr_seq_prestador_p;
			 
			/*Se o tipo de prestador for pessoa física buscará o país da tabela PESSOA_FISICA*/
 
			if (ie_tipo_prestador_w	= 'PF')	then 
				/*Buscar o do prestador*/
 
				select	max(x.cd_pessoa_fisica) 
				into STRICT 	cd_codigo_prestador_w 
				from	pls_prestador	x 
				where	x.nr_sequencia = nr_seq_prestador_p;
				 
			/*Se o tipo de prestador for pessoa jurídica buscará o país da tabela PESSOA_JURIDICA*/
 
			elsif (ie_tipo_prestador_w	= 'PJ')	then 
				select	max(x.cd_cgc) 
				into STRICT 	cd_codigo_prestador_w 
				from	pls_prestador	x 
				where	x.nr_sequencia = nr_seq_prestador_p;
				 
			end if;
			 
			nr_seq_pais_cooperativa_w	:= pls_obter_pais_abrang(cd_cgc_congenere_w,'PJ');
			nr_seq_pais_prestador_w		:= pls_obter_pais_abrang(cd_codigo_prestador_w,ie_tipo_prestador_w);
		 
			/*Compara se o país do prestador é igual ao país da cooperativa*/
		 
			if (nr_seq_pais_prestador_w IS NOT NULL AND nr_seq_pais_prestador_w::text <> '')   then 
				if (nr_seq_pais_cooperativa_w = nr_seq_pais_prestador_w)	then 
					ie_area_coberta_w := 'S';
					return ie_area_coberta_w;
				end if;
			else 
				ie_area_coberta_w    := 'S';
				return ie_area_coberta_w;
			end if;
		end if;
	end if;
end if;
 
return	ie_area_coberta_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_abran_event ( nr_seq_prestador_p pls_prestador.nr_sequencia%type, nr_seq_segurado_p pls_segurado.nr_sequencia%type, nr_seq_cooperativa_p pls_congenere.nr_sequencia%type, nr_seq_plano_p pls_plano.nr_sequencia%type, ie_abrangencia_p pls_plano.ie_abrangencia%type) FROM PUBLIC;

