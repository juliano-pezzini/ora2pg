-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE duv_gerar_mensagens_episodio (nr_seq_episodio_p episodio_paciente.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, ie_acao_p text default 'FC') AS $body$
DECLARE


/*ie_acao_p
FC - Fechar conta paciente
NC - Adicionar novo case
*/
nr_seq_mensagem_w			duv_mensagem.nr_sequencia%type;

nr_seq_versao_mens_w		duv_versao_mensagem.nr_sequencia%type;

nr_seq_regra_versao_w		duv_regra_versao.nr_sequencia%type;

nr_seq_versao_w				duv_versao.nr_sequencia%type;

nr_seq_nodo_w				duv_mensagem_segmento.nr_seq_nodo%type;

nr_seq_mens_seg_w			duv_mensagem_segmento.nr_sequencia%type;

cont_w						bigint;



c01 CURSOR FOR

SELECT	*

from	atendimento_paciente

where	nr_seq_episodio		= nr_seq_episodio_p;



c02 CURSOR(nr_atendimento_cp 	atendimento_paciente.nr_atendimento%type)FOR

SELECT	*

from	atend_categoria_convenio

where	nr_atendimento		= nr_atendimento_cp

order 	by dt_inicio_vigencia;



c03 CURSOR(cd_convenio_cp			duv_regra_mensagem.cd_convenio%type,

			nr_seq_tipo_acidente_cp	duv_regra_mensagem.nr_seq_tipo_acidente%type) FOR

SELECT	*

from	duv_regra_mensagem

where	cd_convenio		= cd_convenio_cp

and		coalesce(nr_seq_tipo_acidente, 0)	= coalesce(nr_seq_tipo_acidente_cp, 0)

order	by coalesce(nr_seq_tipo_acidente, 0);



-- identificar os tipos de mensagens a serem geradas
c04 CURSOR(nr_seq_regra_versao_cp	duv_regra_mens_item.nr_seq_regra_versao%type) FOR

SELECT	a.nr_seq_tipo_mensagem

from	duv_regra_mens_item a

where	a.nr_seq_regra_versao			= nr_seq_regra_versao_cp;



-- identificar os segmentos das 
c05 CURSOR(nr_seq_versao_mens_cp	duv_tipo_mens_segmento.nr_seq_versao_mens%type) FOR

SELECT	a.*

from	duv_tipo_mens_segmento a

where	a.nr_seq_versao_mens			= nr_seq_versao_mens_cp;
BEGIN



for	r_c01_w in c01 loop



	for	r_c02_w in c02(r_c01_w.nr_atendimento) loop

	

		for	r_c03_w in c03(r_c02_w.cd_convenio, r_c01_w.nr_seq_tipo_acidente) loop

		

			select	max(nr_sequencia),

					max(nr_seq_versao)

			into STRICT	nr_seq_regra_versao_w,

					nr_seq_versao_w

			from	duv_regra_versao

			where	nr_seq_regra_mens		= r_c03_w.nr_sequencia;

		

		end loop;

	

	end loop;



end loop;

/*
delete	from duv_mensagem_segmento
where	nr_seq_mensagem	in
		(select	nr_sequencia
		 from	duv_mensagem
		 where	nr_seq_episodio	 = nr_seq_episodio_p);*/
delete	from	duv_mensagem
where	nr_seq_episodio	 = nr_seq_episodio_p;		

-- cursor dos tipos de mensagens
for	r_c04_w in c04(nr_seq_regra_versao_w) loop

	select	max(nr_sequencia)
	into STRICT	nr_seq_mensagem_w
	from	duv_mensagem
	where	nr_seq_episodio		= nr_seq_episodio_p
	and	nr_seq_tipo_mensagem	= r_c04_w.nr_seq_tipo_mensagem;	

	if (coalesce(nr_seq_mensagem_w::text, '') = '') then
		nr_seq_mensagem_w := duv_gerar_mensagem(nr_seq_episodio_p, r_c04_w.nr_seq_tipo_mensagem, nr_seq_versao_w, nr_seq_mensagem_w, nm_usuario_p);
	end if;	

	-- obter a versao da mensaagem
	select	max(nr_sequencia)

	into STRICT	nr_seq_versao_mens_w

	from	duv_versao_mensagem

	where	nr_seq_tipo_mensagem		= r_c04_w.nr_seq_tipo_mensagem

	and	nr_seq_versao				= nr_seq_versao_w;

	

	-- cursor dos segmentos
	for	r_c05_w in c05(nr_seq_versao_mens_w) loop



		select	count(*)

		into STRICT	cont_w

		from	duv_mensagem_segmento

		where	nr_seq_mensagem		= nr_seq_mensagem_w

		and		ie_tipo_segmento	= r_c05_w.ie_tipo_segmento;



		if (cont_w = 0) then

			insert	into duv_mensagem_segmento(nr_sequencia,

				dt_atualizacao,

				nm_usuario,

				dt_atualizacao_nrec,

				nm_usuario_nrec,

				nr_seq_mensagem,

				ie_tipo_segmento,

				nr_seq_apres)

			values (nextval('duv_mensagem_segmento_seq'),

				clock_timestamp(),

				nm_usuario_p,

				clock_timestamp(),

				nm_usuario_p,

				nr_seq_mensagem_w,

				r_c05_w.ie_tipo_segmento,

				r_c05_w.nr_seq_apres) returning nr_sequencia into nr_seq_mens_seg_w;

		end if;


        case r_c05_w.ie_tipo_segmento
		when 'aba' then

			duv_gerar_segmento_aba(nr_seq_mensagem_w, nm_usuario_p, nr_seq_episodio_p);

			nr_seq_nodo_w	:= 1042366;

		when 'abs' then

			duv_gerar_segmento_abs(nr_seq_mensagem_w, nm_usuario_p,nr_seq_episodio_p);

			nr_seq_nodo_w	:= 1042266;

		when 'adb' then
    
      duv_gerar_segmento_adb(nr_seq_mensagem_w,nm_usuario_p,nr_seq_episodio_p);

			nr_seq_nodo_w	:= 1042271;

		when 'afb' then

			duv_gerar_segmento_afb(nr_seq_mensagem_w, nm_usuario_p,nr_seq_episodio_p);

			nr_seq_nodo_w	:= 1042281;

		when 'anl' then

      duv_gerar_segmento_anl(nr_seq_mensagem_w, nm_usuario_p,nr_seq_episodio_p);
			
			nr_seq_nodo_w	:= 1042286;

		when 'ass' then

			duv_gerar_segmento_ass(nr_seq_mensagem_w, nm_usuario_p,nr_seq_episodio_p);

			nr_seq_nodo_w	:= 1042276;

		when 'atm' then

			duv_gerar_segmento_atm(nr_seq_mensagem_w, nm_usuario_p,nr_seq_episodio_p);

			nr_seq_nodo_w	:= 1042159;

		when 'auf' then

			duv_gerar_segmento_auf(nr_seq_mensagem_w, nm_usuario_p,nr_seq_episodio_p);

			nr_seq_nodo_w	:= 1042416;

		when 'bbv' then

      duv_gerar_segmento_bbv(nr_seq_mensagem_w, nm_usuario_p,nr_seq_episodio_p);
			
			nr_seq_nodo_w	:= 1042411;

		when 'bed' then

			duv_gerar_segmento_bed(nr_seq_mensagem_w, nm_usuario_p,nr_seq_episodio_p);

			nr_seq_nodo_w	:= 1042441;

		when 'bef' then

      duv_gerar_segmento_bef(nr_seq_mensagem_w, nm_usuario_p,nr_seq_episodio_p);
			
			nr_seq_nodo_w	:= 1042431;

		when 'beh' then

			duv_gerar_segmento_beh(nr_seq_mensagem_w, nm_usuario_p,nr_seq_episodio_p);

			nr_seq_nodo_w	:= 1042426;

		when 'bek' then

      duv_gerar_segmento_bek(nr_seq_mensagem_w, nm_usuario_p,nr_seq_episodio_p);
		
			nr_seq_nodo_w	:= 1042396;

		when 'bem' then

			duv_gerar_segmento_bem(nr_seq_mensagem_w, nm_usuario_p,nr_seq_episodio_p);

			nr_seq_nodo_w	:= 1042421;

		when 'bes' then

			duv_gerar_segmento_bes(nr_seq_mensagem_w, nm_usuario_p,nr_seq_episodio_p);

			nr_seq_nodo_w	:= 1042467;

		when 'bfb' then

			duv_gerar_segmento_bfb(nr_seq_mensagem_w, nm_usuario_p,nr_seq_episodio_p);

			nr_seq_nodo_w	:= 1042447;

		when 'bhi' then

			duv_gerar_segmento_bhi(nr_seq_mensagem_w, nm_usuario_p,nr_seq_episodio_p);

			nr_seq_nodo_w	:= 1042452;

		when 'bnd' then

			duv_gerar_segmento_bnd(nr_seq_mensagem_w, nm_usuario_p,nr_seq_episodio_p);

			nr_seq_nodo_w	:= 1042406;

		when 'bns' then

      duv_gerar_segmento_bns(nr_seq_mensagem_w, nm_usuario_p,nr_seq_episodio_p);
			
			nr_seq_nodo_w	:= 1042462;

		when 'dis' then

			duv_gerar_segmento_dis(nr_seq_mensagem_w, nm_usuario_p,nr_seq_episodio_p);

			nr_seq_nodo_w	:= 1042436;

		when 'ebh' then

      duv_gerar_segmento_ebh(nr_seq_mensagem_w, nm_usuario_p,nr_seq_episodio_p);
		
			nr_seq_nodo_w	:= 1042457;

		when 'eti' then

			duv_gerar_segmento_eti(nr_seq_mensagem_w, nm_usuario_p,nr_seq_episodio_p);

			nr_seq_nodo_w	:= 1042477;

		when 'gck' then

      duv_gerar_segmento_gck(nr_seq_mensagem_w, nm_usuario_p,nr_seq_episodio_p);
			
			nr_seq_nodo_w	:= 1042472;

		when 'gew' then

			duv_gerar_segmento_gew(nr_seq_mensagem_w, nm_usuario_p,nr_seq_episodio_p);

			nr_seq_nodo_w	:= 1042391;

		when 'kdi' then

			duv_gerar_segmento_kdi(nr_seq_mensagem_w, nm_usuario_p,nr_seq_episodio_p);

			nr_seq_nodo_w	:= 1042494;

		when 'kon' then

			duv_gerar_segmento_kon(nr_seq_mensagem_w, nm_usuario_p,nr_seq_episodio_p);

			nr_seq_nodo_w	:= 1042386;

		when 'ksd' then

			duv_gerar_segmento_ksd(nr_seq_mensagem_w, nm_usuario_p,nr_seq_episodio_p);

			nr_seq_nodo_w	:= 1042489;

		when 'kto' then

			duv_gerar_segmento_kto(nr_seq_mensagem_w, nm_usuario_p,nr_seq_episodio_p);

			nr_seq_nodo_w	:= 1042401;

		when 'nah' then

	    duv_gerar_segmento_nah(nr_seq_mensagem_w, nm_usuario_p,nr_seq_episodio_p);
  		
			nr_seq_nodo_w	:= 1042509;

		when 'nbh' then

			duv_gerar_segmento_nbh(nr_seq_mensagem_w, nm_usuario_p,nr_seq_episodio_p);

			nr_seq_nodo_w	:= 1042499;

		when 'not' then

			duv_gerar_segmento_not(nr_seq_mensagem_w, nm_usuario_p,nr_seq_episodio_p);

			nr_seq_nodo_w	:= 1042504;

		when 'rel' then

			duv_gerar_segmento_rel(nr_seq_mensagem_w, nm_usuario_p,nr_seq_episodio_p);

			nr_seq_nodo_w	:= 1042483;

		when 'rma' then

			duv_gerar_segmento_rma(nr_seq_mensagem_w, nm_usuario_p,nr_seq_episodio_p);

			nr_seq_nodo_w	:= 1042529;

		when 'son' then

			duv_gerar_segmento_son(nr_seq_mensagem_w, nm_usuario_p,nr_seq_episodio_p);

			nr_seq_nodo_w	:= 1042524;

		when 'spb' then

			duv_gerar_segmento_spb(nr_seq_mensagem_w, nm_usuario_p,nr_seq_episodio_p);

			nr_seq_nodo_w	:= 1042376;

		when 'sri' then

			duv_gerar_segmento_sri(nr_seq_mensagem_w, nm_usuario_p,nr_seq_episodio_p);

			nr_seq_nodo_w	:= 1042514;

		when 'svb' then

			duv_gerar_segmento_svb(nr_seq_mensagem_w, nm_usuario_p,nr_seq_episodio_p);

			nr_seq_nodo_w	:= 1042519;

		when 'swh' then

			duv_gerar_segmento_swh(nr_seq_mensagem_w, nm_usuario_p,nr_seq_episodio_p);

			nr_seq_nodo_w	:= 1042539;

		when 'swi' then

			duv_gerar_segmento_swi(nr_seq_mensagem_w, nm_usuario_p,nr_seq_episodio_p);

			nr_seq_nodo_w	:= 1042381;

		when 'tab' then

			duv_gerar_segmento_tab(nr_seq_mensagem_w, nm_usuario_p,nr_seq_episodio_p);

			nr_seq_nodo_w	:= 1042534;

		when 'tdh' then

			duv_gerar_segmento_tdh(nr_seq_mensagem_w, nm_usuario_p,nr_seq_episodio_p);

			nr_seq_nodo_w	:= 1042554;

		when 'tkn' then

			duv_gerar_segmento_tkn(nr_seq_mensagem_w, nm_usuario_p,nr_seq_episodio_p);

			nr_seq_nodo_w	:= 1042544;

		when 'tko' then

			duv_gerar_segmento_tko(nr_seq_mensagem_w, nm_usuario_p,nr_seq_episodio_p);

			nr_seq_nodo_w	:= 1042371;

		when 'tre' then

			duv_gerar_segmento_tre(nr_seq_mensagem_w, nm_usuario_p,nr_seq_episodio_p);

			nr_seq_nodo_w	:= 1042549;

		when 'tsu' then

			duv_gerar_segmento_tsu(nr_seq_mensagem_w, nm_usuario_p,nr_seq_episodio_p);

			nr_seq_nodo_w	:= 1042291;

		when 'tve' then

			duv_gerar_segmento_tve(nr_seq_mensagem_w, nm_usuario_p,nr_seq_episodio_p);

			nr_seq_nodo_w	:= 1042316;

		when 'ufb' then

			duv_gerar_segmento_ufb(nr_seq_mensagem_w, nm_usuario_p,nr_seq_episodio_p);

			nr_seq_nodo_w	:= 1042311;

		when 'ufd' then

			duv_gerar_segmento_ufd(nr_seq_mensagem_w, nm_usuario_p,nr_seq_episodio_p);

			nr_seq_nodo_w	:= 1042361;

		when 'unb' then

			duv_gerar_segmento_unb(nr_seq_mensagem_w, nm_usuario_p,nr_seq_episodio_p);

			nr_seq_nodo_w	:= 1042321;

		when 'unh' then

			duv_gerar_segmento_unh(nr_seq_mensagem_w, nm_usuario_p,nr_seq_episodio_p);

			nr_seq_nodo_w	:= 1042326;

		when 'uuk' then

			duv_gerar_segmento_uuk(nr_seq_mensagem_w, nm_usuario_p,nr_seq_episodio_p);

			nr_seq_nodo_w	:= 1042331;

		when 'uvt' then

			duv_gerar_segmento_uvt(nr_seq_mensagem_w, nm_usuario_p,nr_seq_episodio_p);

			nr_seq_nodo_w	:= 1042301;

		when 'vav' then

			duv_gerar_segmento_vav(nr_seq_mensagem_w, nm_usuario_p,nr_seq_episodio_p);

			nr_seq_nodo_w	:= 1042341;

		when 'ver' then

			duv_gerar_segmento_ver(nr_seq_mensagem_w, nm_usuario_p,nr_seq_episodio_p);

			nr_seq_nodo_w	:= 1042351;

		when 'vin' then

			duv_gerar_segmento_vin(nr_seq_mensagem_w, nm_usuario_p,nr_seq_episodio_p);

			nr_seq_nodo_w	:= 1042336;

		when 'vne' then

			duv_gerar_segmento_vne(nr_seq_mensagem_w, nm_usuario_p,nr_seq_episodio_p);

			nr_seq_nodo_w	:= 1042306;

		when 'wbe' then

			duv_gerar_segmento_wbe(nr_seq_mensagem_w, nm_usuario_p,nr_seq_episodio_p);

			nr_seq_nodo_w	:= 1042296;

		when 'wme' then

			duv_gerar_segmento_wme(nr_seq_mensagem_w, nm_usuario_p,nr_seq_episodio_p);

			nr_seq_nodo_w	:= 1042346;

		when 'wub' then

			duv_gerar_segmento_wub(nr_seq_mensagem_w, nm_usuario_p,nr_seq_episodio_p);

			nr_seq_nodo_w	:= 1042356;

		end case;

		

		update	duv_mensagem_segmento
		set	nr_seq_nodo	= nr_seq_nodo_w
		where	nr_sequencia	= nr_seq_mens_seg_w;
		
				

	end loop;
	
	CALL DUV_CONSISTE_MENSAGEM(nr_seq_mensagem_w,null,null,nm_usuario_p);

end loop;

/*'Efetuado essa chamada para liberacao das mensagens de envio da troca do tipo do case, que sao conformadas apenas no fim do breadcrumb'*/

CALL liberar_envio_troca_tipo_case(nr_seq_episodio_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE duv_gerar_mensagens_episodio (nr_seq_episodio_p episodio_paciente.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, ie_acao_p text default 'FC') FROM PUBLIC;

