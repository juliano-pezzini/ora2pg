-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_nom_rc_diagnostico_pac (nr_seq_cabecalho_p bigint, nm_usuario_p text) AS $body$
DECLARE



/* Diagnósticos y problemas de salud */

nr_atendimento_w			atendimento_paciente.nr_atendimento%type;
nr_seq_episodio_w			episodio_paciente.nr_sequencia%type;
cd_estabelecimento_w		estabelecimento.cd_estabelecimento%type;
qt_registro_w		bigint	:= 0;
ds_html_w		varchar(32000);
ds_oid_w				varchar(255);

c_lista_problema CURSOR FOR
	SELECT	lista_problema.*,
			row_number() OVER () AS cd_ordem_diag /* 305 */
	from (
		SELECT  l.dt_inicio,	/*302*/
				l.dt_fim,       /*303*/
				l.nr_sequencia cd_problema,	/*304*/
				'282291009' cd_tipo_diagnostico,    /*306*/
				'Diagnóstico' ds_tipo_diagnostico,  /*307*/
				l.ds_problema ds_diagnostico,  /*308*/
				l.ds_observacao ds_observacao,
				l.cd_doenca cd_doenca_cid,    /*309*/
				coalesce(l.ds_problema, obter_desc_cid_doenca(l.cd_doenca)) ds_doenca  /*310*/
		from    lista_problema_pac l
		where 	nr_atendimento in (select		x.nr_atendimento
										from	nom_rc_cabecalho x
										where	x.nr_sequencia = nr_seq_cabecalho_p
										and		(x.nr_atendimento IS NOT NULL AND x.nr_atendimento::text <> '')
										
union

										select	y.nr_atendimento
										from	atendimento_paciente y,
												nom_rc_cabecalho x
										where	x.nr_seq_episodio = y.nr_seq_episodio
										and		x.nr_sequencia = nr_seq_cabecalho_p)
		and		(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
		and		coalesce(dt_inativacao::text, '') = ''
		order by coalesce(dt_inicio,dt_liberacao)
	) lista_problema;

BEGIN



delete from nom_rc_diagnostico_pac
where nr_seq_cabecalho = nr_seq_cabecalho_p;

select	a.nr_atendimento,
		a.nr_seq_episodio,
		a.cd_estabelecimento
into STRICT	nr_atendimento_w,
		nr_seq_episodio_w,
		cd_estabelecimento_w
from	nom_rc_cabecalho a
where	a.nr_sequencia	= nr_seq_cabecalho_p;

ds_oid_w	:= get_oid_details(21,'OID_NUMBER', 'NOM', cd_estabelecimento_w);

if (nr_atendimento_w IS NOT NULL AND nr_atendimento_w::text <> '') then
	null;
elsif (nr_seq_episodio_w IS NOT NULL AND nr_seq_episodio_w::text <> '') then
	select	min(nr_atendimento)
	into STRICT	nr_atendimento_w
	from	atendimento_paciente a
	where	a.nr_seq_episodio = nr_seq_episodio_w;
end if;

ds_html_w	:= '<table class="wrichedit-table" width="100%" xmlns="urn:hl7-org:v3">';
ds_html_w	:= ds_html_w || chr(13) || chr(10) || chr(9) || '<thead>';

ds_html_w	:= ds_html_w || chr(13) || chr(10) || chr(9) || chr(9) || '<tr>';
ds_html_w	:= ds_html_w || chr(13) || chr(10) || chr(9) || chr(9) || chr(9) || '<th>Tipo</th>';
ds_html_w	:= ds_html_w || chr(13) || chr(10) || chr(9) || chr(9) || chr(9) || '<th>Fecha</th>';
ds_html_w	:= ds_html_w || chr(13) || chr(10) || chr(9) || chr(9) || chr(9) || '<th>CIE-10</th>';
ds_html_w	:= ds_html_w || chr(13) || chr(10) || chr(9) || chr(9) || chr(9) || '<th>Diagnóstico</th>';
ds_html_w	:= ds_html_w || chr(13) || chr(10) || chr(9) || chr(9) || chr(9) || '<th>Observaciones</th>';
ds_html_w	:= ds_html_w || chr(13) || chr(10) || chr(9) || chr(9) || '</tr>';
ds_html_w	:= ds_html_w || chr(13) || chr(10) || chr(9) ||  '</thead>';

ds_html_w	:= ds_html_w || chr(13) || chr(10) || chr(9) || '<tbody>';

if (nr_atendimento_w IS NOT NULL AND nr_atendimento_w::text <> '') then
	for	r_c_lista_problema in c_lista_problema loop
		qt_registro_w	:= qt_registro_w + 1;

		insert into nom_rc_diagnostico_pac(nr_sequencia,
			nm_usuario,
			dt_atualizacao,
			nm_usuario_nrec,
			dt_atualizacao_nrec,
			dt_inicio,
			dt_fim,
			cd_problema,
			cd_ordem_diag,
			cd_tipo_diagnostico,
			ds_tipo_diagnostico,
			ds_diagnostico,
			ds_observacao,
			cd_doenca_cid,
			nr_seq_cabecalho,
			ds_oid)
		values (nextval('nom_rc_diagnostico_pac_seq'),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			r_c_lista_problema.dt_inicio,
			r_c_lista_problema.dt_fim,
			r_c_lista_problema.cd_problema,
			r_c_lista_problema.cd_ordem_diag,
			r_c_lista_problema.cd_tipo_diagnostico,
			r_c_lista_problema.ds_tipo_diagnostico,
			r_c_lista_problema.ds_doenca,
			r_c_lista_problema.ds_observacao,
			r_c_lista_problema.cd_doenca_cid,
			nr_seq_cabecalho_p,
			ds_oid_w);

		if (length(ds_html_w) < 31000) then
			ds_html_w	:= ds_html_w || chr(13) || chr(10) || chr(9) || chr(9) || '<tr>';

			ds_html_w	:= ds_html_w || chr(13) || chr(10) || chr(9) || chr(9) || chr(9) || '<td>' || r_c_lista_problema.ds_tipo_diagnostico || '</td>';
			ds_html_w	:= ds_html_w || chr(13) || chr(10) || chr(9) || chr(9) || chr(9) || '<td>' || obter_data_utc(r_c_lista_problema.dt_inicio,'NOM_TABLE') ||'</td>';
			ds_html_w	:= ds_html_w || chr(13) || chr(10) || chr(9) || chr(9) || chr(9) || '<td>' || r_c_lista_problema.cd_doenca_cid  || '</td>';
			ds_html_w	:= ds_html_w || chr(13) || chr(10) || chr(9) || chr(9) || chr(9) || '<td>' || r_c_lista_problema.ds_doenca || '</td>';
			ds_html_w	:= ds_html_w || chr(13) || chr(10) || chr(9) || chr(9) || chr(9) || '<td>' || r_c_lista_problema.ds_observacao || '</td>';

			ds_html_w	:= ds_html_w || chr(13) || chr(10) || chr(9) || chr(9) || '</tr>';
		end if;
	end loop;
end if;

if (qt_registro_w = 0) then
	ds_html_w	:= ds_html_w || chr(13) || chr(10) || chr(9) || chr(9) || '<tr>';

	ds_html_w	:= ds_html_w || chr(13) || chr(10) || chr(9) || chr(9) || chr(9) || '<td></td>';
	ds_html_w	:= ds_html_w || chr(13) || chr(10) || chr(9) || chr(9) || chr(9) || '<td></td>';
	ds_html_w	:= ds_html_w || chr(13) || chr(10) || chr(9) || chr(9) || chr(9) || '<td></td>';
	ds_html_w	:= ds_html_w || chr(13) || chr(10) || chr(9) || chr(9) || chr(9) || '<td></td>';
	ds_html_w	:= ds_html_w || chr(13) || chr(10) || chr(9) || chr(9) || chr(9) || '<td></td>';

	ds_html_w	:= ds_html_w || chr(13) || chr(10) || chr(9) || chr(9) || '</tr>';
end if;

ds_html_w	:= ds_html_w || chr(13) || chr(10) || chr(9) || '</tbody>';

ds_html_w	:= ds_html_w || chr(13) || chr(10) || '</table>';


insert into nom_rc_diagnostico_pac(nr_sequencia,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	nr_seq_cabecalho,
	ds_html,
	ds_oid)
values (nextval('nom_rc_diagnostico_pac_seq'),
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	nr_seq_cabecalho_p,
	ds_html_w,
	ds_oid_w);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_nom_rc_diagnostico_pac (nr_seq_cabecalho_p bigint, nm_usuario_p text) FROM PUBLIC;
