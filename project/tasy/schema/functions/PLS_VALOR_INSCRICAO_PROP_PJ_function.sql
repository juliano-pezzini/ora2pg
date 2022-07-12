-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_valor_inscricao_prop_pj ( nr_seq_proposta_p bigint, nr_seq_plano_p bigint) RETURNS bigint AS $body$
DECLARE

			 
nr_seq_proposta_benef_w		bigint;
vl_proposta_benef_w		double precision;
vl_tot_proposta_benef_w		double precision;
vl_inscricao_w			double precision;
tx_inscricao_w			double precision;
nr_seq_regra_w			bigint;
dt_inicio_proposta_w		timestamp;
ie_taxa_inscricao_w		varchar(10);
ie_tipo_proposta_w		smallint;
ie_acao_contrato_w		varchar(10);
nr_contrato_w			bigint;
nr_seq_contrato_w		bigint;
qt_registros_w			bigint;
qt_reg_proposta_w		bigint;

C01 CURSOR FOR 
	SELECT	nr_sequencia, 
		coalesce(ie_taxa_inscricao,'S') 
	from	pls_proposta_beneficiario 
	where	nr_seq_proposta	= nr_seq_proposta_p 
	and	nr_seq_plano	= nr_seq_plano_p;


BEGIN 
 
vl_tot_proposta_benef_w	:= 0;
 
select	dt_inicio_proposta, 
	ie_tipo_proposta, 
	nr_seq_contrato 
into STRICT	dt_inicio_proposta_w, 
	ie_tipo_proposta_w, 
	nr_contrato_w 
from	pls_proposta_adesao 
where	nr_sequencia	= nr_seq_proposta_p;
 
if (nr_contrato_w IS NOT NULL AND nr_contrato_w::text <> '') then 
	select	max(nr_sequencia) 
	into STRICT	nr_seq_contrato_w 
	from	pls_contrato 
	where	nr_contrato = nr_contrato_w;
end if;
 
qt_registros_w	:= 0;
 
if (nr_seq_contrato_w IS NOT NULL AND nr_seq_contrato_w::text <> '') then 
	select	count(1) 
	into STRICT	qt_registros_w 
	from	pls_regra_inscricao 
	where	nr_seq_contrato	= nr_seq_contrato_w;	
end if;
 
if (ie_tipo_proposta_w in (1,6,7)) then 
	ie_acao_contrato_w	:= 'A';
elsif (ie_tipo_proposta_w in (2,8)) then 
	ie_acao_contrato_w	:= 'L';
elsif (ie_tipo_proposta_w in (3,4,7,8)) then 
	ie_acao_contrato_w	:= 'M';
end if;
 
if (qt_registros_w = 0) then 
	select	count(1) 
	into STRICT	qt_reg_proposta_w 
	from	pls_regra_inscricao 
	where	nr_seq_proposta	= nr_seq_proposta_p;	
	 
	if (qt_reg_proposta_w = 0) then 
		/*Taxa de inscrição no produto*/
 
		open C01;
		loop 
		fetch C01 into	 
			nr_seq_proposta_benef_w, 
			ie_taxa_inscricao_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin 
			vl_inscricao_w		:= 0;
			tx_inscricao_w		:= 0;
			vl_proposta_benef_w	:= 0;
			 
			if (ie_taxa_inscricao_w = 'S') then 
				SELECT * FROM pls_obter_taxa_inscricao(nr_seq_proposta_benef_w, null, null, nr_seq_plano_p, null, 1, dt_inicio_proposta_w, null, ie_acao_contrato_w, nr_seq_regra_w, vl_inscricao_w, tx_inscricao_w) INTO STRICT nr_seq_regra_w, vl_inscricao_w, tx_inscricao_w;				
				 
				 
				if (coalesce(tx_inscricao_w,0) <> 0) then			 
					vl_proposta_benef_w	:= pls_obter_valores_propostas(nr_seq_proposta_benef_w,null,'P');
					vl_proposta_benef_w := dividir((vl_proposta_benef_w * tx_inscricao_w), 100); 						
				elsif (coalesce(vl_inscricao_w,0) <> 0) then 
					 
					vl_proposta_benef_w := vl_inscricao_w;
				end if;	
				 
				if (coalesce(vl_proposta_benef_w,0) <> 0) then 
					vl_tot_proposta_benef_w	:= vl_tot_proposta_benef_w + vl_proposta_benef_w;
				end if;
			end if;
			 
			end;
		end loop;
		close C01;
	else 
		/*Taxa de inscrição proposta*/
 
		open C01;
		loop 
		fetch C01 into	 
			nr_seq_proposta_benef_w, 
			ie_taxa_inscricao_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin 
			vl_inscricao_w		:= 0;
			tx_inscricao_w		:= 0;
			vl_proposta_benef_w	:= 0;
			if (ie_taxa_inscricao_w = 'S') then		 
			 
				SELECT * FROM pls_obter_taxa_inscricao(nr_seq_proposta_benef_w, null, null, null, nr_seq_proposta_p, 1, dt_inicio_proposta_w, null, ie_acao_contrato_w, nr_seq_regra_w, vl_inscricao_w, tx_inscricao_w) INTO STRICT nr_seq_regra_w, vl_inscricao_w, tx_inscricao_w;	
				 
				if (coalesce(tx_inscricao_w,0) <> 0) then			 
					vl_proposta_benef_w	:= pls_obter_valores_propostas(nr_seq_proposta_benef_w,null,'P');
					vl_proposta_benef_w := dividir((vl_proposta_benef_w * tx_inscricao_w), 100); 						
				elsif (coalesce(vl_inscricao_w,0) <> 0) then 				 
					vl_proposta_benef_w := vl_inscricao_w;
				end if;	
				 
				if (coalesce(vl_proposta_benef_w,0) <> 0) then 
					vl_tot_proposta_benef_w	:= vl_tot_proposta_benef_w + vl_proposta_benef_w;
				end if;
			end if;				
			end;
		end loop;
		close C01;
	end if;
else 
	/*Taxa de inscrição contrato*/
 
	open C01;
	loop 
	fetch C01 into	 
		nr_seq_proposta_benef_w, 
		ie_taxa_inscricao_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin 
		vl_inscricao_w		:= 0;
		tx_inscricao_w		:= 0;
		vl_proposta_benef_w	:= 0;
		if (ie_taxa_inscricao_w = 'S') then 
			SELECT * FROM pls_obter_taxa_inscricao(nr_seq_proposta_benef_w, nr_seq_contrato_w, null, null, nr_seq_proposta_p, 1, dt_inicio_proposta_w, null, ie_acao_contrato_w, nr_seq_regra_w, vl_inscricao_w, tx_inscricao_w) INTO STRICT nr_seq_regra_w, vl_inscricao_w, tx_inscricao_w;				
			 
			 
			if (coalesce(tx_inscricao_w,0) <> 0) then			 
				vl_proposta_benef_w	:= pls_obter_valores_propostas(nr_seq_proposta_benef_w,null,'P');
				vl_proposta_benef_w := dividir((vl_proposta_benef_w * tx_inscricao_w), 100); 						
			elsif (coalesce(vl_inscricao_w,0) <> 0) then 				 
				vl_proposta_benef_w := vl_inscricao_w;
			end if;	
			 
			if (coalesce(vl_proposta_benef_w,0) <> 0) then 
				vl_tot_proposta_benef_w	:= vl_tot_proposta_benef_w + vl_proposta_benef_w;
			end if;
		end if;				
		end;
	end loop;
	close C01;
end if;
 
return	vl_tot_proposta_benef_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_valor_inscricao_prop_pj ( nr_seq_proposta_p bigint, nr_seq_plano_p bigint) FROM PUBLIC;

