-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE limpar_requisicao_material () AS $body$
DECLARE


nr_requisicao_w		bigint;
qt_itens_w		bigint;
qt_itens_pend_w		bigint;
dt_liberacao_w		timestamp;
dt_requisicao_w		timestamp;
qt_dia_nao_lib_w		smallint;
qt_dia_lib_w		smallint;
ie_limpa_sem_mat_w	varchar(1);
ie_limpa_nao_lib_w		varchar(1);
ie_limpa_req_liberada_w	varchar(1);
cd_estabelecimento_w	smallint;
qt_existe_w		smallint;
qt_reg_w			smallint;

c01 CURSOR FOR
SELECT	a.cd_estabelecimento
from	requisicao_material a,
	local_estoque b
where	a.cd_local_estoque = b.cd_local_estoque
and	coalesce(a.dt_baixa::text, '') = ''
and	coalesce(b.ie_limpa_requisicao,'S') = 'S'
and	not exists (	select	1
			from   	item_requisicao_material x
			where	x.nr_requisicao = a.nr_requisicao
			and	(x.dt_atendimento IS NOT NULL AND x.dt_atendimento::text <> ''))
group by a.cd_estabelecimento;

c02 CURSOR FOR
SELECT	a.nr_requisicao,
	a.dt_liberacao,
	a.dt_solicitacao_requisicao
from	requisicao_material a,
	local_estoque b
where	a.cd_local_estoque = b.cd_local_estoque
and	a.cd_estabelecimento = cd_estabelecimento_w
and	coalesce(a.dt_baixa::text, '') = ''
and	coalesce(b.ie_limpa_requisicao,'S') = 'S'
and	not exists (	select	1
			from   	item_requisicao_material x
			where	x.nr_requisicao = a.nr_requisicao
			and	(x.dt_atendimento IS NOT NULL AND x.dt_atendimento::text <> ''))
order by a.nr_requisicao;


BEGIN
qt_reg_w := 0;

open c01;
loop
fetch c01 into
	cd_estabelecimento_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	select	count(*)
	into STRICT	qt_existe_w
	from	parametro_estoque
	where	cd_estabelecimento = cd_estabelecimento_w;

	if (qt_existe_w > 0) then
		begin
		select	coalesce(max(qt_dias_req_sem_lib),500),
			coalesce(max(coalesce(qt_dias_req_lib, qt_dias_req_sem_lib)), 500),
			coalesce(max(ie_limpa_req_nao_lib), 'N'),
			coalesce(max(ie_limpa_req_sem_item), 'N'),
			coalesce(max(ie_limpa_req_liberada), 'N')
		into STRICT	qt_dia_nao_lib_w,
			qt_dia_lib_w,
			ie_limpa_nao_lib_w,
			ie_limpa_sem_mat_w,
			ie_limpa_req_liberada_w
		from	parametro_estoque
		where	cd_estabelecimento = cd_estabelecimento_w;

		open c02;
		loop
		fetch c02 into
			nr_requisicao_w,
			dt_liberacao_w,
			dt_requisicao_w;
		EXIT WHEN NOT FOUND; /* apply on c02 */
			begin
			select	count(*),
				sum(CASE WHEN coalesce(obter_tipo_motivo_baixa_req(cd_motivo_baixa),0)=0 THEN 1  ELSE 0 END )
			into STRICT	qt_itens_w,
				qt_itens_pend_w
			from	item_requisicao_material
			where	nr_requisicao = nr_requisicao_w;

			if (qt_itens_w = 0) and (ie_limpa_sem_mat_w = 'S') then
				begin
				begin
				delete
				from	requisicao_material
				where	nr_requisicao = nr_requisicao_w;
				exception
					when others then
						/*para que baixe quando gerar um erro, por exemplo se existir uma ordem de compra com esta requisição*/

						update	requisicao_material
						set	dt_baixa = clock_timestamp()
						where	nr_requisicao = nr_requisicao_w;
				end;

				begin
				CALL gravar_log_exclusao('REQUISICAO_MATERIAL', 'Tasy', nr_requisicao_w,'N');
				exception
					when others then
						nr_requisicao_w	:= nr_requisicao_w;
				end;
				end;
			elsif (coalesce(dt_liberacao_w::text, '') = '') and (ie_limpa_nao_lib_w = 'S') and ((clock_timestamp() - dt_requisicao_w) > qt_dia_nao_lib_w) then
				begin
				begin
				delete
				from	requisicao_material
				where	nr_requisicao = nr_requisicao_w;
				exception
					when others then
						update	requisicao_material
						set	dt_baixa = clock_timestamp()
						where	nr_requisicao = nr_requisicao_w;
				end;

				begin
				CALL gravar_log_exclusao('REQUISICAO_MATERIAL','Tasy', nr_requisicao_w,'N');
				exception
					when others then
						nr_requisicao_w	:= nr_requisicao_w;
				end;
				end;
			elsif (dt_liberacao_w IS NOT NULL AND dt_liberacao_w::text <> '') and (ie_limpa_req_liberada_w = 'S') and ((clock_timestamp() - dt_requisicao_w) > qt_dia_lib_w) then
				begin
				begin
				delete
				from	requisicao_material
				where	nr_requisicao = nr_requisicao_w;
				exception
					when others then
						update	requisicao_material
						set	dt_baixa = clock_timestamp()
						where	nr_requisicao = nr_requisicao_w;
				end;

				begin
				CALL gravar_log_exclusao('REQUISICAO_MATERIAL','Tasy', nr_requisicao_w,'N');
				exception
					when others then
						nr_requisicao_w	:= nr_requisicao_w;
				end;
				end;
			elsif (qt_itens_pend_w = 0) then
				update	requisicao_material
				set	dt_baixa = clock_timestamp()
				where	nr_requisicao = nr_requisicao_w;
			end if;

			qt_reg_w := qt_reg_w + 1;

			if (qt_reg_w > 500) then
				begin
				commit;
				qt_reg_w := 0;
				end;
			end if;
			end;
		end loop;
		close c02;
		end;
	end if;
	end;
end loop;
close c01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE limpar_requisicao_material () FROM PUBLIC;
