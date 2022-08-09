-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE lab_atualizar_result_pardini ( ds_campo_valor_p text, valor_exame_filho_P text, ds_unidade_medida_p text, ds_referencia_p text, ds_observacao_p text, nr_seq_resultado_p text, nr_seq_exame_p text, nr_seq_prescr_p text, sql_unid_med_p text, sql_unid_med_bv text, sql_refer_p text, sql_refer_bv text, sql_observacao_p text, sql_observacao_bv text, nm_usuario_p text) AS $body$
DECLARE


pr_resultado_w	exame_lab_result_item.pr_resultado%type := null;
qt_resultado_w	exame_lab_result_item.qt_resultado%type := null;
ds_resultado_w	exame_lab_result_item.ds_resultado%type := null;


BEGIN

if (nr_seq_resultado_p IS NOT NULL AND nr_seq_resultado_p::text <> '') and (nr_seq_prescr_p IS NOT NULL AND nr_seq_prescr_p::text <> '') and (nr_seq_exame_p IS NOT NULL AND nr_seq_exame_p::text <> '') then
	
	update	exame_lab_result_item
	set		ds_referencia 		= ds_referencia_p,
			ds_referencia_ext 	= ds_referencia_p
	where 	nr_seq_resultado 	= nr_seq_resultado_p  	
	and 	nr_seq_prescr 		= nr_seq_prescr_p
	and		(nr_seq_material IS NOT NULL AND nr_seq_material::text <> '');
	
	if (upper(ds_campo_valor_p) = upper('pr_resultado')) then
        begin
		pr_resultado_w := (coalesce(replace(valor_exame_filho_p, '.', null),'0'))::numeric;
        exception
            when data_exception then
                ds_resultado_w := trim(both valor_exame_filho_p);
        end;
	elsif (upper(ds_campo_valor_p) = upper('qt_resultado')) then
		begin
			qt_resultado_w := (coalesce(valor_exame_filho_p,'0'))::numeric;
		exception
			when data_exception then
			begin
				qt_resultado_w := (coalesce(replace(valor_exame_filho_p, '.', null),'0'))::numeric;
			exception
				when data_exception then
					ds_resultado_w := trim(both valor_exame_filho_p);
			end;
		end;
	else
		ds_resultado_w := valor_exame_filho_p;
	end if;
	
	update 	exame_lab_result_item
	set 	ds_resultado	 	= ds_resultado_w,     
			qt_resultado		= qt_resultado_w,
			pr_resultado		= pr_resultado_w,
			nm_usuario 		 	= nm_usuario_p,
			ds_unidade_medida 	= substr(ds_unidade_medida_p, 1, 40),
			ds_referencia 		= ds_referencia_p,
			ds_referencia_ext 	= ds_referencia_p, 
			ds_observacao		= ds_observacao_p 
	where 	nr_seq_resultado 	= nr_seq_resultado_p  
	and 	nr_seq_exame 		= nr_seq_exame_p  
	and 	nr_seq_prescr 		= nr_seq_prescr_p;
	
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE lab_atualizar_result_pardini ( ds_campo_valor_p text, valor_exame_filho_P text, ds_unidade_medida_p text, ds_referencia_p text, ds_observacao_p text, nr_seq_resultado_p text, nr_seq_exame_p text, nr_seq_prescr_p text, sql_unid_med_p text, sql_unid_med_bv text, sql_refer_p text, sql_refer_bv text, sql_observacao_p text, sql_observacao_bv text, nm_usuario_p text) FROM PUBLIC;
