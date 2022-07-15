-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cme_devolver_item_requisicao ( nr_requisicao_p bigint, nr_seq_item_req_p bigint, nr_seq_item_atend_p bigint, ie_baixa_item_p text, nm_usuario_p text) AS $body$
DECLARE


nr_seq_conjunto_w		bigint;
qt_conj_item_baixado_w		integer;
qt_conj_nao_atendido_w		integer;
nr_seq_item_req_destino_w	bigint;
qt_conj_atual_w			bigint;
nr_seq_conj_real_w		bigint;
ie_status_conj_devol_req_w	smallint;
cd_estabelecimento_w		smallint := wheb_usuario_pck.get_cd_estabelecimento;
ie_manter_conj_atend_w		varchar(1);
cd_motivo_baixa_w		smallint;
ie_desvincular_cirurgia_w	varchar(1);


BEGIN

ie_status_conj_devol_req_w := Obter_Param_Usuario(410, 11, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_status_conj_devol_req_w);
ie_manter_conj_atend_w := Obter_Param_Usuario(410, 26, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_manter_conj_atend_w);
ie_desvincular_cirurgia_w := Obter_Param_Usuario(406, 159, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_desvincular_cirurgia_w);

select	max(nr_seq_conjunto)
into STRICT	nr_seq_conjunto_w
from	cm_requisicao_item
where	nr_sequencia 		= nr_seq_item_req_p;

select	max(nr_seq_conj_real)
into STRICT	nr_seq_conj_real_w
from	cm_requisicao_conj
where	nr_sequencia 		= nr_seq_item_atend_p
and	nr_seq_item_req 		= nr_seq_item_req_p;

update	cm_conjunto_cont
set	cd_setor_atend_dest	 = NULL,
	nm_usuario		= nm_usuario_p,
	dt_atualizacao		= clock_timestamp()
where	nr_sequencia 		= nr_seq_conj_real_w;

update	cm_requisicao_item
set		dt_devolucao 		= clock_timestamp()
where	nr_sequencia 		= nr_seq_item_req_p
and		nr_seq_requisicao 	= nr_requisicao_p
and		nr_seq_conjunto		= nr_seq_conjunto_w;


if (ie_status_conj_devol_req_w > 0) then
	update	cm_conjunto_cont
	set	ie_status_conjunto	= ie_status_conj_devol_req_w,
		nm_usuario		= nm_usuario_p,
		dt_atualizacao		= clock_timestamp()
	where	nr_sequencia 	= nr_seq_conj_real_w;
end if;

if (coalesce(ie_desvincular_cirurgia_w,'N') = 'S') then
	update	cm_conjunto_cont
	set	nr_cirurgia		 = NULL,
		nr_atendimento		 = NULL,
		nm_usuario		= nm_usuario_p,
		dt_atualizacao		= clock_timestamp()
	where	nr_sequencia 		= nr_seq_conj_real_w;
end if;	

delete from cm_requisicao_conj
where	nr_sequencia 		= nr_seq_item_atend_p
and	nr_seq_item_req 	= nr_seq_item_req_p;

if (ie_manter_conj_atend_w = 'N') then
	begin

	update	cm_requisicao
	set	dt_atualizacao 		= clock_timestamp(),
		dt_baixa 			 = NULL,
		nm_usuario		= nm_usuario_p
	where	nr_sequencia 		= nr_requisicao_p
	and	(dt_baixa IS NOT NULL AND dt_baixa::text <> '');

	end;
end if;

select	count(*)
into STRICT	qt_conj_item_baixado_w
from	cm_requisicao_conj
where	nr_seq_item_req = nr_seq_item_req_p;

if (qt_conj_item_baixado_w = 0) and (ie_manter_conj_atend_w = 'N') then

	update	cm_requisicao_item
	set	dt_atualizacao		= clock_timestamp(),
		cd_motivo_baixa		 = NULL,
		nm_usuario		= nm_usuario_p,
		nm_usuario_atend  = NULL
	where	nr_sequencia 		= nr_seq_item_req_p
	and	nr_seq_requisicao 		= nr_requisicao_p
	and	nr_seq_conjunto		= nr_seq_conjunto_w;
	
	
	select	count(*),
		coalesce(max(nr_sequencia),0)
	into STRICT	qt_conj_nao_atendido_w,
		nr_seq_item_req_destino_w
	from	cm_requisicao_item
	where	nr_sequencia <> nr_seq_item_req_p
	and	coalesce(cd_motivo_baixa::text, '') = ''
	and	nr_seq_conjunto 		= nr_seq_conjunto_w
	and	nr_seq_requisicao 		= nr_requisicao_p;

	if (qt_conj_nao_atendido_w > 0) and (nr_seq_item_req_destino_w > 0) then

		select	coalesce(qt_conjunto,0)
		into STRICT	qt_conj_atual_w
		from	cm_requisicao_item 
		where	nr_sequencia 	= nr_seq_item_req_p;

		update	cm_requisicao_item
		set	qt_conjunto 	= qt_conjunto + qt_conj_atual_w
		where	nr_sequencia 	= nr_seq_item_req_destino_w
		and	nr_seq_conjunto	= nr_seq_conjunto_w
		and	nr_seq_requisicao 	= nr_requisicao_p;
		
		delete from cm_requisicao_item
		where	nr_sequencia 	= nr_seq_item_req_p
		and	nr_seq_conjunto	= nr_seq_conjunto_w;
	end if;
	
	if (ie_baixa_item_p = 'S') then
		
		cd_motivo_baixa_w := coalesce(obter_valor_param_usuario(406, 155, Obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w),0);
		
		update	cm_requisicao_item
		set	cd_motivo_baixa = cd_motivo_baixa_w
		where	nr_sequencia = nr_seq_item_req_p
		and	nr_seq_requisicao = nr_requisicao_p
		and	nr_seq_conjunto = nr_seq_conjunto_w;
	end if;

elsif (qt_conj_item_baixado_w > 0) and (ie_manter_conj_atend_w = 'N') then
	
	begin

	update	cm_requisicao_item
	set	qt_conjunto		= qt_conjunto - 1
	where	nr_sequencia 		= nr_seq_item_req_p
	and	nr_seq_requisicao		= nr_requisicao_p
	and	nr_seq_conjunto		= nr_seq_conjunto_w;
	

	select	nextval('cm_requisicao_item_seq')
	into STRICT	nr_seq_item_req_destino_w
	;

	insert into cm_requisicao_item(
			nr_sequencia,
			nr_seq_requisicao,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_seq_conjunto,
			qt_conjunto)
		values (nr_seq_item_req_destino_w,
			nr_requisicao_p,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_conjunto_w,
			1);
	
	select	coalesce(max(nr_sequencia),0)
	into STRICT	nr_seq_item_req_destino_w
	from	cm_requisicao_item
	where	nr_seq_conjunto 	= nr_seq_conjunto_w
	and	coalesce(cd_motivo_baixa::text, '') = ''
	and	nr_sequencia <> nr_seq_item_req_p
	and	nr_seq_conjunto	= nr_seq_conjunto_w
	and	nr_seq_requisicao = nr_requisicao_p;

	select	coalesce(sum(qt_conjunto),0)
	into STRICT	qt_conj_nao_atendido_w
	from	cm_requisicao_item
	where	nr_seq_conjunto = nr_seq_conjunto_w
	and	coalesce(cd_motivo_baixa::text, '') = ''
	and	nr_sequencia <> nr_seq_item_req_p
	and	nr_sequencia <> nr_seq_item_req_destino_w
	and	nr_seq_requisicao = nr_requisicao_p;

	if (qt_conj_nao_atendido_w > 0) and (nr_seq_item_req_destino_w > 0) then

		update	cm_requisicao_item
		set	qt_conjunto 		= (qt_conj_nao_atendido_w + 1)
		where	nr_sequencia 		= nr_seq_item_req_destino_w
		and	nr_seq_conjunto		= nr_seq_conjunto_w;
		
	end if;

	delete from cm_requisicao_item
	where	nr_sequencia 	<>  nr_seq_item_req_destino_w
	and	coalesce(cd_motivo_baixa::text, '') = ''
	and	nr_seq_conjunto	= nr_seq_conjunto_w
	and	nr_seq_requisicao	= nr_requisicao_p;

	end;
end if;

commit;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cme_devolver_item_requisicao ( nr_requisicao_p bigint, nr_seq_item_req_p bigint, nr_seq_item_atend_p bigint, ie_baixa_item_p text, nm_usuario_p text) FROM PUBLIC;

