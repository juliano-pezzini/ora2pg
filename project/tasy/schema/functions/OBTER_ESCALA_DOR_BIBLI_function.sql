-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_escala_dor_bibli (cd_escala_dor_p text) RETURNS varchar AS $body$
DECLARE

				
ds_escala_bibliografia_w		varchar(4000) := '';
ds_escala_bibliografia_pais_w	varchar(4000);
ds_locale_w						escala_doc_locale.cd_pais%type;
qt_records_w					integer;


BEGIN

ds_locale_w := coalesce(coalesce(pkg_i18n.get_user_locale,philips_param_pck.get_ds_locale),'pt_BR');

	if (cd_escala_dor_p IS NOT NULL AND cd_escala_dor_p::text <> '') then
		begin
		
			select		coalesce(substr(obter_desc_expressao(a.cd_exp_informacao),1,4000), a.ds_doc_cliente)
			into STRICT			ds_escala_bibliografia_w
			from			escala_dor_documentacao a
			where			a.cd_escala_dor = cd_escala_dor_p;
			
			select			count(*)
			into STRICT			qt_records_w
			from			escala_dor_doc_locale a,
							escala_dor_documentacao b
			where 			a.nr_seq_escala_doc = b.nr_sequencia
			and 			b.cd_escala_dor       = cd_escala_dor_p
			and				a.cd_pais          = ds_locale_w;
			
			  
			if (qt_records_w > 0) then
			  
				select		max(substr(coalesce(obter_desc_expressao(a.cd_exp_ref_bibli), a.desc_doc_cliente),1,4000))
				into STRICT		ds_escala_bibliografia_pais_w
				from		escala_dor_doc_locale a,
							escala_dor_documentacao b
				where		a.nr_seq_escala_doc = b.nr_sequencia
				and			b.cd_escala_dor       = cd_escala_dor_p
				and			a.cd_pais          = ds_locale_w;
				
			end if;
		  
		end;
		
	end if;
	
	if (ds_escala_bibliografia_pais_w IS NOT NULL AND ds_escala_bibliografia_pais_w::text <> '') then

		ds_escala_bibliografia_w	:= ds_escala_bibliografia_pais_w;
	
	end if;

return	ds_escala_bibliografia_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_escala_dor_bibli (cd_escala_dor_p text) FROM PUBLIC;
