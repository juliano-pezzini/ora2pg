-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE hd_teste_reuso_apc ( nr_teste_p bigint, nr_seq_dialisador_p bigint, cd_estabelecimento_p bigint, dt_teste_p timestamp, ie_resultado_p text, nm_usuario_p text) AS $body$
DECLARE



nr_seq_unid_dialise_w		bigint;
nr_seq_hd_teste_reuso_w	hd_teste_reuso.nr_sequencia%type;
ie_parametro_90_w 	varchar(1);
qt_reuso_w			smallint;
qt_reuso_max_w			bigint;
ie_tipo_w			varchar(1);

BEGIN
ie_parametro_90_w := obter_valor_param_usuario(7009, 90, obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento);

if (coalesce(ie_resultado_p::text, '') = '') then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(233282);
end if;

select	nextval('hd_teste_reuso_seq')
into STRICT	nr_seq_hd_teste_reuso_w
;
/* Insere os dados do teste */

insert into hd_teste_reuso(
	nr_sequencia,
  cd_estabelecimento,
  dt_atualizacao,
  nm_usuario,
  dt_atualizacao_nrec,
  nm_usuario_nrec,
  dt_teste,
  nr_teste,
  ie_resultado,
  cd_pf_teste,
  nr_seq_dialisador
) values (
	nr_seq_hd_teste_reuso_w,
  cd_estabelecimento_p,
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	dt_teste_p,
  nr_teste_p,
	ie_resultado_p,
	substr(obter_pessoa_fisica_usuario(nm_usuario_p,'C'),1,10),
	nr_seq_dialisador_p
);

if (ie_parametro_90_w = 'N') and (nr_teste_p = 1) and (ie_resultado_p = 'N') then
	/* Atualizar status do dialisador */

	update	hd_dializador
	set    	ie_status              	= 'P'
	where  	nr_sequencia		= nr_seq_dialisador_p;

	/* Verifica se chegou ao reuso máximo, neste caso o dialisador será descartado de forma automática */

	select	max(qt_reuso),
		max(nr_max_reuso),
		max(ie_tipo)
	into STRICT	qt_reuso_w,
		qt_reuso_max_w,
		ie_tipo_w	
	from	hd_dializador
	where	nr_sequencia		= nr_seq_dialisador_p;	

	if (ie_tipo_w = 'U') then /* Envia dialisador de único uso para descarte */
		CALL HD_Descarte_Dialisador(nr_seq_dialisador_p, 'UU', 'U', nm_usuario_p);				
	elsif (qt_reuso_w+1 > qt_reuso_max_w) and (qt_reuso_max_w > 0) then /* Envia dialisador com reuso máximo para descarte - SOMENTE PARA DIALISADORES QUE NÃO SÃO DE 1º USO*/
		CALL HD_Descarte_Dialisador(nr_seq_dialisador_p, 'RE', 'U', nm_usuario_p);			
	end if;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE hd_teste_reuso_apc ( nr_teste_p bigint, nr_seq_dialisador_p bigint, cd_estabelecimento_p bigint, dt_teste_p timestamp, ie_resultado_p text, nm_usuario_p text) FROM PUBLIC;
