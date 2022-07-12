-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dieta_servico_concat ( nr_seq_servico_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	        varchar(4000):= '';
ds_retorno2_w	        varchar(80) := '';
nr_seq_apres_w	        bigint;
ie_base_conduta_w       varchar(1);
nr_prescr_conduta_w        prescr_medica.nr_prescricao%type;

C01 CURSOR FOR
	SELECT	coalesce(a.nm_curto,a.nm_dieta),
		coalesce(d.nr_seq_apres,999)
	FROM nut_atend_serv_dia_dieta b, dieta a
LEFT OUTER JOIN dieta_classif d ON (a.nr_seq_classif = d.nr_sequencia)
WHERE a.cd_dieta = b.cd_dieta  and b.nr_seq_servico = nr_seq_servico_p and coalesce(b.dt_suspensao::text, '') = '' order by 2,1;

C02 CURSOR FOR
	SELECT	coalesce(a.nm_curto,a.nm_dieta),
		coalesce(d.nr_seq_apres,999)
	FROM nut_atend_serv_dieta c, nut_atend_serv_dia_dieta b, dieta a
LEFT OUTER JOIN dieta_classif d ON (a.nr_seq_classif = d.nr_sequencia)
WHERE a.cd_dieta = b.cd_dieta and c.nr_seq_dieta = b.nr_sequencia  and c.nr_seq_servico = nr_seq_servico_p and coalesce(b.dt_suspensao::text, '') = '' and (b.dt_liberacao IS NOT NULL AND b.dt_liberacao::text <> '')
	
union

	SELECT	a.ds_produto||' '||b.qt_dose||' '||b.cd_unidade_medida_dosa,
		99999
	from	nutricao_produto a,
		nut_atend_serv_dia_dieta b,
		nut_atend_serv_dieta c
	where	a.nr_sequencia = b.nr_seq_produto
	and	c.nr_seq_dieta = b.nr_sequencia
	and	c.nr_seq_servico = nr_seq_servico_p
	and	coalesce(b.dt_suspensao::text, '') = ''
	
union

	select	a.nm_produto||' '||b.qt_dose||' '||b.cd_unidade_medida_dosa,
		99999
	from	nutricao_leite_deriv a,
		nut_atend_serv_dia_dieta b,
		nut_atend_serv_dieta c
	where	a.nr_sequencia = b.nr_seq_leite_deriv
	and	c.nr_seq_dieta = b.nr_sequencia
	and	c.nr_seq_servico = nr_seq_servico_p
	and	coalesce(b.dt_suspensao::text, '') = ''
	and coalesce(a.ie_situacao,'A') = 'A'
	order by 2,1;
	

BEGIN

ie_base_conduta_w := obter_valor_param_usuario(1003,85,obter_perfil_ativo,wheb_usuario_pck.get_nm_usuario,wheb_usuario_pck.get_cd_estabelecimento);

if (ie_base_conduta_w = 'S') then

        open C01;
        loop
        fetch C01 into	
                ds_retorno2_w,
                nr_seq_apres_w;
        EXIT WHEN NOT FOUND; /* apply on C01 */
                begin
                ds_retorno_w := ds_retorno_w|| ds_retorno2_w||'  ';
                end;
        end loop;
        close C01;

        open C02;
        loop
        fetch C02 into	
                ds_retorno2_w,
                nr_seq_apres_w;
        EXIT WHEN NOT FOUND; /* apply on C02 */
                begin
                ds_retorno_w := ds_retorno_w|| ds_retorno2_w||'  ';
                end;
        end loop;
        close C02;

        if (ds_retorno_w IS NOT NULL AND ds_retorno_w::text <> '') then
                ds_retorno_w := substr(ds_retorno_w,1,length(ds_retorno_w)-2);
        end if;

else
        
        select max(coalesce(nr_prescr_oral, nr_prescr_jejum)) 
        into STRICT    nr_prescr_conduta_w
        from    nut_atend_serv_dia_rep
        where   nr_seq_serv_dia = nr_seq_servico_p;

        if (nr_prescr_conduta_w IS NOT NULL AND nr_prescr_conduta_w::text <> '') then
                ds_retorno_w := nut_obter_dietas_serv_def(nr_seq_servico_p);
        end if;
        
end if;
return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dieta_servico_concat ( nr_seq_servico_p bigint) FROM PUBLIC;

