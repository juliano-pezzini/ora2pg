-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION apap_dinamico_pck.get_valores_pac (nr_seq_mod_apap_p bigint) RETURNS SETOF VALORES_PAC_T AS $body$
DECLARE

valores_pac_r_w         valores_pac_r;
valores_pac_sup_v_w		valores_pac_t	:= valores_pac_t();
vl_param_regra_destaque_w  varchar(15);
ie_alerta_w                varchar(1);

c_valores CURSOR FOR
   SELECT   distinct c.nr_sequencia nr_seq_grupo,
			c.ds_grupo_informacao,
			d.nr_sequencia nr_seq_linha,
			d.ds_informacao,
			e.nr_sequencia nr_seq_valor,
			d.nm_atributo,
			d.nm_tabela,
			e.vl_resultado,
			e.vl_pad,
			e.vl_pas,
			e.vl_pam,
			e.vl_papd,
			e.vl_paps,
			e.vl_papm,
			e.ds_resultado,
			e.dt_resultado,
			e.dt_registro,
			d.nr_seq_linked_data,
			e.dt_inicio,
			e.dt_fim,
			coalesce(e.ds_profissional,obter_pf_usuario(e.nm_usuario,'D')) ds_profissional,
			coalesce(e.ie_alerta,'N') ie_alerta,
			b.nr_atendimento,
			d.nm_atributo_tabela,
			d.nr_seq_superior,
			CASE WHEN coalesce(e.nr_seq_origem::text, '') = '' THEN 'N'  ELSE 'S' END  ie_readonly,
			e.ds_tooltip,
			e.vl_grafico,
			e.ie_status,
                        e.nr_seq_origem
   from     documento a,
			w_apap_pac b,
			w_apap_pac_grupo c,
			w_apap_pac_informacao d,
			w_apap_pac_registro e
   where    a.nr_sequencia       = b.nr_seq_documento
   and      b.nr_sequencia       = c.nr_seq_mod_apap
   and      c.nr_sequencia       = d.nr_seq_apap_grupo
   and      d.nr_sequencia       = e.nr_seq_apap_inf
   and      c.ie_padrao_visivel  = 'S'
   and      d.ie_visivel         in ('S','F')
   and      b.nr_sequencia       = nr_seq_mod_apap_p;
BEGIN
obter_param_usuario(1355, 4, wheb_usuario_pck.get_cd_perfil, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento, vl_param_regra_destaque_w);
<<read_valores>>
for r_valores in c_valores
	loop
	valores_pac_r_w.nr_seq_grupo        := r_valores.nr_seq_grupo;
	valores_pac_r_w.ds_grupo_informacao := r_valores.ds_grupo_informacao;
	valores_pac_r_w.nr_seq_linha        := r_valores.nr_seq_linha;
	valores_pac_r_w.ds_informacao       := r_valores.ds_informacao;
	valores_pac_r_w.nr_seq_valor        := r_valores.nr_seq_valor;
	valores_pac_r_w.nm_atributo         := r_valores.nm_atributo;
	valores_pac_r_w.nm_tabela           := r_valores.nm_tabela;
	valores_pac_r_w.vl_resultado        := r_valores.vl_resultado;
	valores_pac_r_w.vl_pad              := r_valores.vl_pad;
	valores_pac_r_w.vl_pas              := r_valores.vl_pas;
	valores_pac_r_w.vl_pam              := r_valores.vl_pam;
	valores_pac_r_w.vl_papd             := r_valores.vl_papd;
	valores_pac_r_w.vl_paps             := r_valores.vl_paps;
	valores_pac_r_w.vl_papm             := r_valores.vl_papm;
	valores_pac_r_w.ds_resultado        := r_valores.ds_resultado;
	valores_pac_r_w.dt_resultado        := r_valores.dt_resultado;
	valores_pac_r_w.dt_registro         := r_valores.dt_registro;
	valores_pac_r_w.nr_seq_linked_data  := r_valores.nr_seq_linked_data;
	valores_pac_r_w.dt_inicio           := r_valores.dt_inicio;
	valores_pac_r_w.ie_readonly         := r_valores.ie_readonly;
	valores_pac_r_w.ds_tooltip         	:= r_valores.ds_tooltip;
	valores_pac_r_w.ie_status         	:= r_valores.ie_status;
	valores_pac_r_w.vl_grafico         	:= r_valores.vl_grafico;
	
	if (r_valores.dt_inicio IS NOT NULL AND r_valores.dt_inicio::text <> '') then
		valores_pac_r_w.dt_fim          := coalesce(r_valores.dt_fim,clock_timestamp());
	else	
		valores_pac_r_w.dt_fim			:= null;
	end if;
	valores_pac_r_w.ds_profissional     := r_valores.ds_profissional;
	valores_pac_r_w.ie_alerta           := r_valores.ie_alerta;
	if (vl_param_regra_destaque_w <> 'N') and (r_valores.nm_tabela = 'ATENDIMENTO_SINAL_VITAL') and (r_valores.vl_resultado IS NOT NULL AND r_valores.vl_resultado::text <> '') then
		select  coalesce(max('S'),'N')
		into STRICT    ie_alerta_w
		from    w_limites_sv_atend a,
				sinal_vital b
		where   a.nr_seq_sinal_vital = b.nr_sequencia
		and     a.nr_atendimento     = r_valores.nr_atendimento
		and		a.nm_usuario         = wheb_usuario_pck.get_nm_usuario
		and     b.nm_atributo        = r_valores.nm_atributo_tabela
		and		((vl_param_regra_destaque_w = 'A' and ((r_valores.vl_resultado < vl_minimo_aviso) or (r_valores.vl_resultado > vl_maximo_aviso))) or
				(vl_param_regra_destaque_w = 'P' and ((r_valores.vl_resultado < vl_minimo_permitido) or (r_valores.vl_resultado > vl_maximo_permitido))));
		valores_pac_r_w.ie_alerta           := ie_alerta_w;
	end if;
	RETURN NEXT valores_pac_r_w;
	end loop read_valores;
return;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION apap_dinamico_pck.get_valores_pac (nr_seq_mod_apap_p bigint) FROM PUBLIC;
