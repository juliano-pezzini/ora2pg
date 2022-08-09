-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE man_vincular_os_etapa ( nr_seq_proj_cron_etapa_p bigint, nr_seq_ordem_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_proj_cron_w			bigint;
ds_atividade_w			varchar(255);
ds_etapa_w			varchar(4000);
nr_seq_cronograma_w		bigint;
qt_existe_os_w			bigint;
nr_seq_ordem_serv_pai_w		man_ordem_servico.nr_seq_ordem_serv_pai%type;
nr_seq_proj_w			proj_projeto.nr_sequencia%type;
ie_fase_w			proj_cron_etapa.ie_fase%type;


BEGIN

	select	max(mos.nr_seq_ordem_serv_pai)
	into STRICT	nr_seq_ordem_serv_pai_w
	from	man_ordem_servico mos
	where	mos.nr_sequencia = nr_seq_ordem_p;
	
	if (nr_seq_ordem_serv_pai_w IS NOT NULL AND nr_seq_ordem_serv_pai_w::text <> '') then
		begin
			CALL wheb_mensagem_pck.exibir_mensagem_abort(1085000);
		end;
	end if;
	
	select	count(*)
	into STRICT	qt_existe_os_w
	from	man_ordem_servico
	where	nr_sequencia	= nr_seq_ordem_p;
	
	if (qt_existe_os_w = 0) then
		/*(-20011,'Nao existe uma ordem de servico com este numero, verifique.');*/

		CALL wheb_mensagem_pck.exibir_mensagem_abort(263160);
	end if;
	
	select	coalesce(max('S'), 'N')
	into STRICT	ie_fase_w
	from	proj_cron_etapa ce
	where	ce.nr_seq_superior = nr_seq_proj_cron_etapa_p;
	
	if (ie_fase_w = 'S') then
		begin
			CALL wheb_mensagem_pck.exibir_mensagem_abort(1130199);
		end;
	end if;
	
	
	select	nr_seq_proj_cron_etapa
	into STRICT	nr_proj_cron_w
	from	man_ordem_servico
	where	nr_sequencia	= nr_seq_ordem_p;
	
	if (coalesce(nr_proj_cron_w,0) > 0) then
		/*(-20011,'A ordem de servico ja possui uma etapa vinculada');*/

		CALL wheb_mensagem_pck.exibir_mensagem_abort(263162);
	end if;
	
	select	a.nr_seq_cronograma,
		a.ds_atividade,
		a.ds_etapa,
		b.nr_seq_proj
	into STRICT	nr_seq_cronograma_w,
		ds_atividade_w,
		ds_etapa_w,
		nr_seq_proj_w
	from	proj_cron_etapa a,
			proj_cronograma b
	where	a.nr_seq_cronograma = b.nr_sequencia
	and a.nr_sequencia = nr_seq_proj_cron_etapa_p;
	
	CALL verifica_permite_add_os_proj(nr_seq_proj_w, nr_seq_ordem_p);
	
	update	man_ordem_servico
	set	nr_seq_proj_cron_etapa	= nr_seq_proj_cron_etapa_p,
		dt_atualizacao		= clock_timestamp(),
		nm_usuario		= nm_usuario_p
	where	nr_sequencia		= nr_seq_ordem_p;
	
	insert into man_ordem_serv_tecnico(
				nr_sequencia,
				nr_seq_ordem_serv,
				dt_atualizacao,
				nm_usuario,
				ds_relat_tecnico,
				dt_historico,
				ie_origem,
				dt_liberacao,
				nm_usuario_lib)
			values (	nextval('man_ordem_serv_tecnico_seq'),
				nr_seq_ordem_p,
				clock_timestamp(),
				nm_usuario_p,
				'Ordem de servico vinculada a etapa do cronograma. ' || chr(13) || chr(10) ||
				obter_desc_expressao(345369)/*'Atividade: '*/
 	|| ds_atividade_w	|| chr(13) || chr(10) ||
				obter_desc_expressao(697961)	||': '/*'Etapa: '*/ 		|| ds_etapa_w 	|| chr(13) || chr(10) ||
				obter_desc_expressao(286405)	||': '/*'Cronograma: '*/ 	|| nr_seq_cronograma_w,
				clock_timestamp(),
				'I',
				clock_timestamp(),
				nm_usuario_p);
				
	
	update	man_ordem_serv_ativ
	set	nr_seq_proj_cron_etapa = nr_seq_proj_cron_etapa_p
	where	nr_seq_ordem_serv = nr_seq_ordem_p
	and	coalesce(nr_seq_proj_cron_etapa::text, '') = '';
	
	CALL man_ordem_atual_horas_cron(null,nr_seq_proj_cron_etapa_p,nm_usuario_p);			
	commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE man_vincular_os_etapa ( nr_seq_proj_cron_etapa_p bigint, nr_seq_ordem_p bigint, nm_usuario_p text) FROM PUBLIC;
