-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_restr_resc_contrato ( nr_seq_contrato_p bigint, cd_perfil_p text, nm_usuario_p text, ds_tipo_rescisao_p text) RETURNS varchar AS $body$
DECLARE

 
				 
/* ********************************************* 
ds_tipo_rescisao_p 
'C' = Restrição por contrato 
'B' = Restrição por Beneficiário 
********************************************* */
				 
				 
ds_restricao_w			varchar(1) := 'N';
nr_seq_regra_resc_w		pls_regra_resc_usuario.nr_sequencia%type;
ie_restringe_resc_contrato_w	pls_regra_resc_usuario.ie_restringe_resc_contrato%type;
ie_restringe_resc_benef_w	pls_regra_resc_usuario.ie_restringe_resc_benef%type;
nr_seq_regra_resc_usuario	pls_regra_resc_usuario.nr_sequencia%type;
nr_seq_pagador_w		pls_contrato_pagador.nr_sequencia%type;
			
c01 CURSOR FOR 
 
	SELECT	coalesce(ie_restringe_resc_contrato,'N')	ie_restringe_resc_contrato, 
		coalesce(ie_restringe_resc_benef,'N')	ie_restringe_resc_benef 
	from	pls_regra_resc_usuario 
	where	nr_seq_resc_contrato			= nr_seq_regra_resc_w 
	and	(((nm_usuario_param IS NOT NULL AND nm_usuario_param::text <> '') and nm_usuario_param = nm_usuario_p) 
	or ((cd_perfil IS NOT NULL AND cd_perfil::text <> '') and cd_perfil = cd_perfil_p ));
	

BEGIN 
if (nr_seq_contrato_p IS NOT NULL AND nr_seq_contrato_p::text <> '') then	 
 	select	max(nr_sequencia) 
	into STRICT	nr_seq_pagador_w 
	from 	pls_contrato_pagador 
	where 	nr_seq_contrato = nr_seq_contrato_p 
	and   ie_tipo_pagador = 'P';
 
	select	max(nr_sequencia) 
	into STRICT	nr_seq_regra_resc_w 
	from	pls_regra_resc_contrato 
	where	((nr_seq_contrato = nr_seq_contrato_p) or (coalesce(nr_seq_contrato::text, '') = '')) 
	and 	((ie_tipo_contrato = pls_obter_dados_contrato(nr_seq_contrato_p,'TE')) 
	or (coalesce(ie_tipo_contrato,'A') = 'A')) 
	and 	((ie_tipo_pagador = pls_obter_dados_pagador(nr_seq_pagador_w, 'T')) 
	or (coalesce(ie_tipo_pagador,'A') = 'A')) 
	and	ie_situacao = 'A' 
	order by nr_seq_contrato;
	 
	if (nr_seq_regra_resc_w IS NOT NULL AND nr_seq_regra_resc_w::text <> '') then	 
		open c01;
		loop 
		fetch c01 into	 
			ie_restringe_resc_contrato_w, 
			ie_restringe_resc_benef_w;
		EXIT WHEN NOT FOUND; /* apply on c01 */
			begin					 
				if (ds_tipo_rescisao_p = 'C' and ie_restringe_resc_contrato_w = 'S') then 
					ds_restricao_w := 'S';
				elsif (ds_tipo_rescisao_p = 'B' and ie_restringe_resc_benef_w = 'S') then 
					ds_restricao_w:= 'S';
				else 
					ds_restricao_w:= 'N';
				end if;	
			end;	
		end loop;
		close c01;		
	end if;
end if;
 
return	ds_restricao_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_restr_resc_contrato ( nr_seq_contrato_p bigint, cd_perfil_p text, nm_usuario_p text, ds_tipo_rescisao_p text) FROM PUBLIC;

