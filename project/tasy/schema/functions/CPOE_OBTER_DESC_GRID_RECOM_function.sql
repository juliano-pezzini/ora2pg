-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION cpoe_obter_desc_grid_recom ( DS_RECOMENDACAO_P text, DS_INTERVALO_GRID_P text, dt_lib_suspensao_p timestamp default null, dt_suspensao_p timestamp default null, ie_administracao_p text default null, ds_observacao_p text default null, ie_baixado_por_alta_p cpoe_recomendacao.ie_baixado_por_alta%type default null, dt_alta_medico_p cpoe_recomendacao.dt_alta_medico%type default null, ds_horarios_p cpoe_recomendacao.ds_horarios%type default null, ie_adep_p text default 'N', nr_seq_topografia_p cpoe_recomendacao.nr_seq_topografia%type default null, dt_fim_grid_p timestamp default null, ie_revalidacao_p text default 'N', nr_seq_cpoe_p cpoe_recomendacao.nr_sequencia%type default null) RETURNS varchar AS $body$
DECLARE

					
ds_retorno_w	varchar(4000);				
desc_topografia_dor_w	topografia_dor.ds_topografia%type;
ds_observacao_w cpoe_recomendacao.ds_recomendacao%type;
ds_tempo_adm_grid_w			varchar(100);
ds_retorno_tag_w varchar(1000);
ds_class_tag_w   varchar(5);
ie_needs_ackn_interface_w 	varchar(2);
ie_confirm_ackn_interface_w	varchar(2);
rule_quantity_w		integer;

		function bold( ds_valor_p text) return text is	
		;
BEGIN
		return '<strong>' ||ds_valor_p||'</strong>';
		
		end;
		
		function cpoe_add_span_adic_info(ds_informacao_p	varchar2, ds_style_adic_p varchar2) return  varchar2 is
		ds_span_w	varchar2(2000);
		begin
			if ((trim(both ds_informacao_p) IS NOT NULL AND (trim(both ds_informacao_p))::text <> '')) then
				begin
				ds_span_w	:= '<span class=''material-adic-info '|| ds_style_adic_p ||'''> '||ds_informacao_p||'</span>';
				end;
			end if;
			return ds_span_w;

		end;
		
		function obter_se_item_futuro(nr_seq_cpoe_p cpoe_recomendacao.nr_sequencia%type, ie_revalidacao_p varchar2)  return varchar2 is
		begin
	
			if (coalesce(ie_revalidacao_p,'N') = 'S') then
				select max(CPOE_obter_prox_adm_grid_ang(  nr_sequencia, 'R',
										nm_usuario, nr_atendimento,
										ie_administracao, cd_intervalo,	
										coalesce(dt_prox_geracao, clock_timestamp()),	
										dt_inicio,dt_fim,			
										'prescr_recomendacao', 'nr_seq_rec_cpoe',
										'prescr_rec_hor', 'nr_seq_recomendacao', null, dt_fim_grid_p, obter_funcao_ativa, ie_revalidacao_p)) ds_tempo_adm_grid
				into STRICT ds_tempo_adm_grid_w
				from cpoe_recomendacao
				where nr_sequencia = nr_seq_cpoe_p
				and (dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
				and coalesce(dt_lib_suspensao::text, '') = '';
			
				if (ds_tempo_adm_grid_w IS NOT NULL AND ds_tempo_adm_grid_w::text <> '') then
					return cpoe_add_span_adic_info(ds_tempo_adm_grid_w, 'cpoe_color_yellow cpoe_text_legend');
				end if;
			end if;
			return null;
		end;
		
	function get_order_interface(	ie_tipo_item_p in varchar2,
									nr_sequencia_p in number) return varchar2 is
	
	begin
		ie_needs_ackn_interface_w := cpoe_integracao_count(ie_tipo_item_p, nr_sequencia_p, 'BTN');
		ie_confirm_ackn_interface_w := cpoe_integracao_count(ie_tipo_item_p, nr_sequencia_p, 'TAG');
		
		if (ie_adep_p = 'S') then
			ds_class_tag_w := 'adep';
		else
			ds_class_tag_w := 'gpt';
		end if;
		
		ds_retorno_tag_w := '</div><div class="legend-cell-status-text-' || ds_class_tag_w ||'" style="cursor: default; flex-wrap: wrap;">
                <div class="legend-cell-content-tag-' || ds_class_tag_w ||'" style="cursor: default;">';

                        
    
		if (ie_adep_p = 'S') then
			ds_retorno_tag_w := ds_retorno_tag_w || '<div class="legend-cell-tag-adep" style="background-color: #FFE9AB; cursor: default; margin-top: 4px;"</div>';			
		else
			ds_retorno_tag_w := ds_retorno_tag_w || '<div class="legend-cell-tag-gpt" style="background-color: #FFE9AB; cursor: default; margin-top: 4px;" </div>';
		end if;
		if (ie_needs_ackn_interface_w = 'S') then
			ds_retorno_tag_w :=  ds_retorno_tag_w || obter_desc_expressao_idioma(1000214, null, wheb_usuario_pck.get_nr_seq_idioma)
			|| ' </div>
              </div>
          </div><div style="display:none">;';
		elsif (ie_confirm_ackn_interface_w = 'S') then
			ds_retorno_tag_w :=  ds_retorno_tag_w || obter_desc_expressao_idioma(1012943, null, wheb_usuario_pck.get_nr_seq_idioma)
			|| ' </div>
              </div>
          </div><div style="display:none">;';
    else
      ds_retorno_tag_w := null;
		end if;
		
    return ds_retorno_tag_w;
	end;
		
begin

if (ds_observacao_p IS NOT NULL AND ds_observacao_p::text <> '') then
	ds_observacao_w := '<br>'||'<div>'|| CPOE_ADD_SPAN(substr(replace(ds_observacao_p,chr(13)||chr(10),'<br>'),1,255)) || '</div>';
end if;

--verifica quais valores serem apresentados para o usuario
if (DS_RECOMENDACAO_P IS NOT NULL AND DS_RECOMENDACAO_P::text <> '') then	
	begin
	desc_topografia_dor_w := obter_desc_topografia_dor(nr_seq_topografia_p);
	if (desc_topografia_dor_w IS NOT NULL AND desc_topografia_dor_w::text <> '') then
		desc_topografia_dor_w := substr(' ' || desc_topografia_dor_w,1,60);
	end if;
	ds_retorno_w := substr(bold(DS_RECOMENDACAO_P) ||CPOE_ADD_SPAN(DS_INTERVALO_GRID_P) || CPOE_ADD_SPAN(ds_horarios_p) || CPOE_OBTER_SIGLA_TIPO_ADM(ie_administracao_p) || desc_topografia_dor_w || ds_observacao_w, 1, 500);
	end;
end if;

if	((dt_lib_suspensao_p IS NOT NULL AND dt_lib_suspensao_p::text <> '') and (dt_suspensao_p IS NOT NULL AND dt_suspensao_p::text <> '') 	     and (dt_suspensao_p <= clock_timestamp()) 	     and (ie_adep_p <> 'S'))		     or
	((coalesce(dt_lib_suspensao_p::text, '') = '')        and (dt_fim_grid_p <= clock_timestamp())           and 
	ie_adep_p = 'N') 
	then
	ds_retorno_w	:= '<del> '|| ds_retorno_w || '</del>';
end if;

ds_retorno_w := ds_retorno_w || obter_se_item_futuro(nr_seq_cpoe_p, ie_revalidacao_p);

select	count(*)
into STRICT	rule_quantity_w
from	cpoe_regra_ator LIMIT 1;
		
if (rule_quantity_w > 0 and (nr_seq_cpoe_p IS NOT NULL AND nr_seq_cpoe_p::text <> '')) then
	ds_retorno_w := ds_retorno_w || get_order_interface('R',nr_seq_cpoe_p);
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cpoe_obter_desc_grid_recom ( DS_RECOMENDACAO_P text, DS_INTERVALO_GRID_P text, dt_lib_suspensao_p timestamp default null, dt_suspensao_p timestamp default null, ie_administracao_p text default null, ds_observacao_p text default null, ie_baixado_por_alta_p cpoe_recomendacao.ie_baixado_por_alta%type default null, dt_alta_medico_p cpoe_recomendacao.dt_alta_medico%type default null, ds_horarios_p cpoe_recomendacao.ds_horarios%type default null, ie_adep_p text default 'N', nr_seq_topografia_p cpoe_recomendacao.nr_seq_topografia%type default null, dt_fim_grid_p timestamp default null, ie_revalidacao_p text default 'N', nr_seq_cpoe_p cpoe_recomendacao.nr_sequencia%type default null) FROM PUBLIC;
