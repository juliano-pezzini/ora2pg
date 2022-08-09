-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE liberar_documento_apap (nr_sequencia_p bigint) AS $body$
DECLARE

							
nm_usuario_w	usuario.nm_usuario%type	:= wheb_usuario_pck.get_nm_usuario;

c_subsecao_families CURSOR FOR
	SELECT	a.nr_sequencia
	from	documento_subsecao a,
			documento_secao b
	where	a.nr_seq_documento_secao 	= b.nr_sequencia
	and		b.ie_row_families 			= 'S'
	and		b.nr_seq_documento			= nr_sequencia_p
	and		not	exists (	SELECT	1
							from	documento_subsecao y,
									documento_secao w
							where	y.nr_seq_documento_secao 	= w.nr_sequencia
							and		w.nr_seq_documento			= b.nr_seq_documento
							and		coalesce(w.ie_row_families,'N')	= 'N'
							and		y.nm_atributo				= a.nm_atributo
							and		y.nr_seq_linked_data		= a.nr_seq_linked_data);

c_subsecao CURSOR FOR
	SELECT	a.ie_mediana,
			a.ie_mediana_10_min,
			a.ie_mediana_15_min,
			a.ie_integracao,
			a.ie_mediana_1_min,
			a.ie_mediana_5_min,
			a.ds_color,
			a.ie_intake_output,
			a.ie_modo,
			a.ie_plot_style,
			a.ie_symbol,
			a.nr_seq_apresentacao,
			a.nr_width,
			a.ie_controla_adep,
			a.nr_escala_maxima,
			a.nr_escala_minima,
			a.ie_trend,
			a.ie_evento_tipo,
			a.nr_sequencia,
			apap_obter_texto_superior(a.nr_sequencia,'F') ds_formato_composto
	from	documento_subsecao a,
			documento_secao b
	where	a.nr_seq_documento_secao 	= b.nr_sequencia
	and		b.nr_seq_documento			= nr_sequencia_p
	and		coalesce(a.nr_seq_superior::text, '') = '';
	
type t_subsecao is table of c_subsecao%rowtype;
subsecao_w    t_subsecao;
	
	
BEGIN

if (obtain_user_locale(wheb_usuario_pck.get_nm_usuario) <> 'ja_JP') then
	update	documento_secao
	set		nr_seq_linked_data 	= row_number() OVER () AS rownum,
			ie_tipo				= CASE WHEN ie_chart_view='S' THEN 'S'  ELSE ie_tipo END
	where	nr_seq_documento 	= nr_sequencia_p;
	commit;
end if;	

<<read_families>>
for r_subsecao_families in c_subsecao_families
	loop
	delete	
	from	documento_subsecao
	where	nr_sequencia = r_subsecao_families.nr_sequencia;
	end loop read_families;


open c_subsecao;
loop fetch c_subsecao bulk collect into subsecao_w limit 1000;
    for i in 1 .. subsecao_w.count loop
    begin
	update	documento_subsecao
	set		ie_mediana			= 	subsecao_w[i].ie_mediana,
			ie_mediana_10_min	=	subsecao_w[i].ie_mediana_10_min,
			ie_mediana_15_min	=	subsecao_w[i].ie_mediana_15_min,
			ie_integracao		=	subsecao_w[i].ie_integracao,
			ie_mediana_1_min	=	subsecao_w[i].ie_mediana_1_min,
			ie_mediana_5_min	=	subsecao_w[i].ie_mediana_5_min,
			ds_color			=	subsecao_w[i].ds_color,
			ie_intake_output	=	subsecao_w[i].ie_intake_output,
			ie_modo				=	subsecao_w[i].ie_modo,
			ie_plot_style		=	subsecao_w[i].ie_plot_style,
			ie_symbol			=	subsecao_w[i].ie_symbol,
			nr_seq_apresentacao	=	subsecao_w[i].nr_seq_apresentacao,
			nr_width			=	subsecao_w[i].nr_width,
			ie_controla_adep	=	subsecao_w[i].ie_controla_adep,
			nr_escala_maxima	=	subsecao_w[i].nr_escala_maxima,
			nr_escala_minima	=	subsecao_w[i].nr_escala_minima,
			ie_trend			=	subsecao_w[i].ie_trend,
			ie_evento_tipo		=	subsecao_w[i].ie_evento_tipo
	where	nr_seq_superior		=	subsecao_w[i].nr_sequencia;
	
	update	documento_subsecao a
	set		a.ds_formato_composto 	= subsecao_w[i].ds_formato_composto
	where	a.nr_sequencia 			= subsecao_w[i].nr_sequencia;
	end;
	end loop;
EXIT WHEN NOT FOUND; /* apply on c_subsecao */
end loop;
close c_subsecao;
	
update	documento
set		dt_liberacao 	= 	clock_timestamp(),
		dt_atualizacao	=	clock_timestamp(),
		nm_usuario		= 	nm_usuario_w
where	nr_sequencia 	= 	nr_sequencia_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE liberar_documento_apap (nr_sequencia_p bigint) FROM PUBLIC;
