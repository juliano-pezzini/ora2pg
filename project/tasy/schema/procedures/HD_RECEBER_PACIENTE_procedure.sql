-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE hd_receber_paciente ( cd_pessoa_fisica_p text, nr_seq_unid_origem_p bigint, nr_seq_unid_destino_p bigint, nr_seq_escala_p bigint, nr_seq_turno_p bigint, nm_pessoa_contato_p text, nm_usuario_p text, ds_dialisador_p text, ds_erro_p INOUT text) AS $body$
DECLARE


cd_estabelecimento_w		smallint;
ds_dialisador_w			varchar(255);
nr_seq_dialisador_w		bigint;
cd_perfil_receber_pac_w		integer;
ds_unidade_origem_w		varchar(80);
vl_parametro_w			varchar(1);
vl_parametro_escala_w		varchar(1);
ie_reg_w				varchar(1);
ie_reg_internacao_externa_w hd_dializador.ie_tipo%type;
c01 CURSOR FOR
	SELECT	nr_sequencia
	from	hd_dializador
	where	obter_se_contido(nr_sequencia,ds_dialisador_p) = 'S';


BEGIN

vl_parametro_w := obter_param_usuario(7009, 169, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, vl_parametro_w);
vl_parametro_escala_w := obter_param_usuario(7009, 170, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, vl_parametro_escala_w);

select	cd_estabelecimento
into STRICT	cd_estabelecimento_w
from	hd_unidade_dialise
where	nr_sequencia		= nr_seq_unid_destino_p;

SELECT CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
INTO STRICT ie_reg_internacao_externa_w
FROM hd_paciente_int_ext a 
WHERE a.cd_pessoa_fisica = cd_pessoa_fisica_p
AND coalesce(a.dt_retorno::text, '') = '';

if	(nr_seq_unid_origem_p = nr_seq_unid_destino_p AND ie_reg_internacao_externa_w = 'N') then
	ds_erro_p	:= wheb_mensagem_pck.get_texto(277365,null);
elsif (coalesce(cd_estabelecimento_w::text, '') = '') then
	ds_erro_p	:= wheb_mensagem_pck.get_texto(277366,null);
elsif (nr_seq_unid_destino_p = 0) then
	ds_erro_p	:= wheb_mensagem_pck.get_texto(277367,null);
elsif	(nr_seq_escala_p = 0 AND vl_parametro_w = 'S') then
	ds_erro_p	:= wheb_mensagem_pck.get_texto(277368,null);
elsif	(nr_seq_turno_p	= 0 AND vl_parametro_w = 'S') then
	ds_erro_p	:= wheb_mensagem_pck.get_texto(277369,null);
else
	begin
	
	select	CASE WHEN count(*)=0 THEN 'N' WHEN count(*)=1 THEN 'S'  ELSE 'N' END
	into STRICT	ie_reg_w
	from	hd_pac_renal_cronico a,
			hd_unidade_dialise b
	where	a.cd_pessoa_fisica = cd_pessoa_fisica_p
	and		a.nr_seq_unidade_atual = b.nr_sequencia
	and		coalesce(b.ie_internacao_externa,'N') = 'S';
	
	if (ie_reg_w <> 'S') or (coalesce(ie_reg_w::text, '') = '') then	
	/* Baixa a escala atual */

		update	hd_escala_dialise
		set		dt_fim			= clock_timestamp()
		where	cd_pessoa_fisica	= cd_pessoa_fisica_p
		and		coalesce(dt_fim::text, '') = '';
	end if;
	
	--atualiza a escala
	update 	hd_pac_renal_cronico
	set	nr_seq_unidade_atual 	= nr_seq_unid_destino_p
	where 	cd_pessoa_fisica 	= cd_pessoa_fisica_p;

  IF (ie_reg_internacao_externa_w = 'S') THEN
		UPDATE  hd_paciente_int_ext a
      		SET a.dt_retorno          = clock_timestamp(),
          		a.dt_atualizacao_nrec = clock_timestamp(),
          		a.nm_usuario_nrec     = nm_usuario_p
    	WHERE 	a.cd_pessoa_fisica = cd_pessoa_fisica_p
      		AND coalesce(a.dt_retorno::text, '') = '';
	END IF;

   UPDATE hd_agenda_dialise
   	  SET dt_atualizacao_nrec = clock_timestamp(),
       nm_usuario_nrec     = nm_usuario_p,
       ie_situacao         = 'A'
 	WHERE cd_pessoa_fisica = cd_pessoa_fisica_p
   	  AND trunc(dt_agenda) >= trunc(clock_timestamp())
      AND ie_situacao = 'T';

	/* Insere a nova escala */

	if (vl_parametro_w = 'S') and (vl_parametro_escala_w = 'N') then
		insert into hd_escala_dialise(
			nr_sequencia,
			cd_estabelecimento,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			cd_pessoa_fisica,
			nr_seq_turno,
			nr_seq_escala,
			dt_inicio,
			nr_seq_unid_dialise,
			dt_prov_volta,
			nm_pessoa_contato
		) values (
			nextval('hd_escala_dialise_seq'),
			cd_estabelecimento_w,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			cd_pessoa_fisica_p,
			nr_seq_turno_p,
			nr_seq_escala_p,
			clock_timestamp(),
			nr_seq_unid_destino_p,
			null,
			nm_pessoa_contato_p
		);
	end if;
	/* Tratamento dos dialisadores */
	
	--ds_dialisador_w		:= ds_dialisador_p;

	--ds_dialisador_w		:= replace(ds_dialisador_w, ',',' ');

	--ds_dialisador_w		:= replace(ds_dialisador_w, '  ',' ');
	
	open c01;
	loop
	fetch c01 into
		nr_seq_dialisador_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
		
		update	hd_dializador
		set	ie_status	= 'T'
		where	nr_sequencia	= nr_seq_dialisador_w;
		
		insert into hd_dialisador_transf(
			nr_sequencia,
			cd_estabelecimento,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_seq_dialisador,
			nr_seq_unid_origem,
			nr_seq_unid_destino,
			dt_transferencia,
			cd_pf_transf,
			ie_tipo
		) values (
			nextval('hd_dialisador_transf_seq'),
			cd_estabelecimento_w,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_dialisador_w,
			nr_seq_unid_origem_p,
			nr_seq_unid_destino_p,
			clock_timestamp(),
			substr(obter_pessoa_fisica_usuario(nm_usuario_p,'C'),1,10),
			'I'
		);
				
		end;
	end loop;
	close c01;
	
	/* Enviar comunicacao ao receber paciente */

	begin
	select	cd_perfil_receber_pac
	into STRICT	cd_perfil_receber_pac_w
	from	hd_parametro
	where	cd_estabelecimento = cd_estabelecimento_w;
	exception
		when others then
		cd_perfil_receber_pac_w	:= 0;
	end;

	if (cd_perfil_receber_pac_w > 0) then
		if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') then
			begin

			ds_unidade_origem_w	:=

substr(HD_Obter_Desc_Unid_Dialise(nr_seq_unid_origem_p),1,80);

			insert into comunic_interna(
				dt_comunicado,
				ds_titulo,
				ds_comunicado,
				nm_usuario,
				dt_atualizacao,
				ie_geral,
				nm_usuario_destino,
				ds_perfil_adicional,
				nr_sequencia,
				ie_gerencial,
				dt_liberacao,
				cd_estab_destino
			) values (
				clock_timestamp(),
				wheb_mensagem_pck.get_texto(795999,'DS_UNIDADE_ORIGEM_W='|| ds_unidade_origem_w),
				wheb_mensagem_pck.get_texto(796003,'NM_PACIENTE='|| cd_pessoa_fisica_p) ||' - '||obter_nome_pf(cd_pessoa_fisica_p),
				nm_usuario_p,
				clock_timestamp(),
				'N',
				'',
				cd_perfil_receber_pac_w ||', ',
				nextval('comunic_interna_seq'),
				'N',
				clock_timestamp(),
				cd_estabelecimento_w
			);
			end;
		end if;
	end if;
	
	commit;	
	exception
		when others then
		rollback;		
	end;
	
end if;	

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE hd_receber_paciente ( cd_pessoa_fisica_p text, nr_seq_unid_origem_p bigint, nr_seq_unid_destino_p bigint, nr_seq_escala_p bigint, nr_seq_turno_p bigint, nm_pessoa_contato_p text, nm_usuario_p text, ds_dialisador_p text, ds_erro_p INOUT text) FROM PUBLIC;

